import Foundation
import SnapKit
import UIKit

class StandingsVC: UIViewController {
    var vm = StandingsVM()

    private var displayedStandingType: DisplayedStandingType = .driver

    let segmentedControl: UISegmentedControl = {
        let standingType = ["Drivers", "Constructors"]
        let sc = UISegmentedControl(items: standingType)
        return sc
    }()

    private let calendarIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: "calendar"))
        icon.tintColor = .red
        return icon
    }()

    // Based on: https://www.uptech.team/blog/build-resizing-image-in-navigation-bar-with-large-title
    private enum Const {
        static let ImageSizeForLargeState: CGFloat = 36 /// Image height/width for Large NavBar state
        static let ImageRightMargin: CGFloat = 16 /// Margin from right anchor of safe area to right anchor of Image
        static let ImageBottomMarginForLargeState: CGFloat = 12 /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 12 /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 28 /// Image height/width for Small NavBar state
        static let NavBarHeightSmallState: CGFloat = 44 /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightLargeState: CGFloat = 96.5 /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    }

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.style = .large
        ai.color = UIColor.red
        return ai
    }()

    private let tableViewHeader: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.allowsSelection = true
        tableView.register(StandingsCell.self, forCellReuseIdentifier: StandingsCell.identifier)
        tableView.isHidden = true
        return tableView
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Failed to load standings. Please try again."
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true // Initially hidden
        return label
    }()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        setupUI()
        activityIndicator.startAnimating()

        scrollViewDidScroll(tableView)
        setupGestureRecognizersAndCallbacks()

        Task {
            await vm.fetchStandings()
        }
    }

    // MARK: UI Setup

    // Based on: https://www.uptech.team/blog/build-resizing-image-in-navigation-bar-with-large-title
    func scrollViewDidScroll(_: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }

    private func setupUI() {
        navigationItem.title = "2023"
        view.backgroundColor = .systemBackground

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()

        tableViewHeader.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50)
        tableView.addSubview(tableViewHeader)
        tableViewHeader.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }

        tableView.tableHeaderView = tableViewHeader

        tableViewHeader.addSubview(segmentedControl)

        segmentedControl.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().offset(-10)
        }

        segmentedControl.addTarget(self, action: #selector(standingTypeDidChange(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0

        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.addSubview(calendarIcon)
        calendarIcon.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        calendarIcon.clipsToBounds = true
        calendarIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Const.ImageRightMargin)
            make.bottom.equalToSuperview().offset(-Const.ImageBottomMarginForLargeState)
            make.height.equalTo(Const.ImageSizeForLargeState)
            make.width.equalTo(calendarIcon.snp.height)
        }

        view.addSubview(tableView)
//        tableView.estimatedRowHeight = 64.0 // Tu podajesz przybliżoną wysokość komórki
        ////        tableView.rowHeight = UITableView.automaticDimension

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }

        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    // Based on: https://www.uptech.team/blog/build-resizing-image-in-navigation-bar-with-large-title
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()

        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState

        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()

        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0

        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff)))
        }()

        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)

        calendarIcon.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }

    // MARK: Selectors & Gesture handling

    private func setupGestureRecognizersAndCallbacks() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(calendarButtonTapped))
        calendarIcon.isUserInteractionEnabled = true
        calendarIcon.addGestureRecognizer(tapGesture)
    }

    @objc private func calendarButtonTapped() {
        // Handle the tap on the calendar icon here
        print("Calendar icon tapped!")
    }

    @objc private func standingTypeDidChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                displayedStandingType = .driver
            case 1:
                displayedStandingType = .constructor
            default:
                break
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        print("TESTTTT")
    }
}

// MARK: Table View Setup

extension StandingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        switch displayedStandingType {
            case .driver:
                return vm.driverStanding.count
            case .constructor:
                return vm.constructorStanding.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StandingsCell", for: indexPath) as? StandingsCell else {
            fatalError("Custom cell error")
        }
        switch displayedStandingType {
            case .driver:
                cell.configureDriverCell(with: vm.driverStanding[indexPath.row], maxPoints: vm.highestPoints ?? 1)
            case .constructor:
                cell.configureConstuctorCell(with: vm.constructorStanding[indexPath.row], maxPoints: vm.constuctorHighestPoints ?? 1)
        }

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 64
    }
}

// MARK: Delegate methods

extension StandingsVC: StandingsVMDelegate {
    func constructorStandingDidUpdate(_: StandingsVM, standing _: [ConstructorStandingModel]) {
        for constructorStanding in vm.constructorStanding {
            print(constructorStanding.constructor.name)
        }
    }

    func standingsDidFailToUpdate(_: StandingsVM, error _: Error) {
        print("Failed to load")

        DispatchQueue.main.async {
            self.errorLabel.isHidden = false
            self.activityIndicator.stopAnimating()
        }
    }

    func driverStandingDidUpdate(_: StandingsVM, standing _: [DriverStandingModel]) {
        print("Data loaded")

        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
            self.errorLabel.isHidden = true
        }

        for driverStanding in vm.driverStanding {
            print(driverStanding.driver.familyName)
        }
    }
}

private enum DisplayedStandingType {
    case driver
    case constructor
}
