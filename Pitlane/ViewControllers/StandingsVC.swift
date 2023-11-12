import Foundation
import SnapKit
import UIKit

class StandingsVC: UIViewController {
    var repository: Repository

    private var driverStanding: [DriverStandingModel] = []
    private var constructorStanding: [ConstructorStandingModel] = []
    
    private var driverStandings: [DriverStandingModel1] = []

    private var highestPoints: Int?
    private var constuctorHighestPoints: Int?

    private let tableView = UITableView()
    private let tableViewHeader = UIView()

    private let standingType = ["Drivers", "Constructors"]
    private var displayedStandingType: DisplayedStandingType = .driver
    private lazy var segmentedControl = UISegmentedControl(items: standingType)

    private let activityIndicator = UIActivityIndicatorView()
    private let errorLabel = UILabel()

    init(repository: Repository) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupActivityIndicator()
        setupErrorLabel()

        activityIndicator.startAnimating()

        Task {
            await fetchStandings()
            await getStandings()
        }
    }

    // MARK: Networking & Data setup

    private func fetchStandings() async {
        do {
            async let driverStandingsResult: NetworkResult<[DriverStandingModel]> = repository.getDriverStanding()
            async let constructorStandingsResult: NetworkResult<[ConstructorStandingModel]> = repository.getConstructorStanding()

            let driverResult = await driverStandingsResult
            let constructorResult = await constructorStandingsResult

            switch (driverResult, constructorResult) {
                case let (.success(fetchedDriverStandings), .success(fetchedConstructorStandings)):
                    driverStanding = fetchedDriverStandings
                    constructorStanding = fetchedConstructorStandings
                    updateDriverHighestPoints()
                    updateConstuctorHighestPoints()

                    // Update the UI directly
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.tableView.isHidden = false
                        self.errorLabel.isHidden = true
                        self.tableView.reloadData()
                    }

                // Handle errors directly in the VC
                case let (.failure(driverError), _):
                    print("Error fetching driver standings")
                    updateUIForError(driverError)

                case let (_, .failure(constructorError)):
                    print("Error fetching constructor standings")
                    updateUIForError(constructorError)
            }
        }
    }
    
    private func getStandings() async {
        let result = await repository.getDriverStandings()
        switch result {
        case .success(let result):
            self.driverStandings = result
            
            for driver in driverStandings {
                print(driver.driver.name)
                print(driver.constructors.name)
            }
        case .failure(let error):
            print(error)
        }
    }

    private func updateUIForError(_: Error) {
        DispatchQueue.main.async {
            self.errorLabel.isHidden = false
            self.activityIndicator.stopAnimating()
        }
    }

    private func updateDriverHighestPoints() {
        highestPoints = driverStanding.compactMap { Int($0.points) }.max()
    }

    private func updateConstuctorHighestPoints() {
        constuctorHighestPoints = constructorStanding.compactMap { Int($0.points) }.max()
    }

    // MARK: UI Setup

    private func setupUI() {
        navigationItem.title = "2023"
        view.backgroundColor = .systemBackground

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()

        setupTableView()
        setupSegmentedControl()
    }

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.UI.background
        tableView.allowsSelection = true
        tableView.register(StandingsCell.self, forCellReuseIdentifier: StandingsCell.identifier)
        tableView.isHidden = true

        tableView.addSubview(tableViewHeader)
        tableViewHeader.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50)
        tableViewHeader.backgroundColor = UIColor.UI.background
        tableView.tableHeaderView = tableViewHeader

        tableViewHeader.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func setupSegmentedControl() {
        tableViewHeader.addSubview(segmentedControl)

        segmentedControl.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().offset(-10)
        }

        segmentedControl.addTarget(self, action: #selector(standingTypeDidChange(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)

        activityIndicator.style = .large
        activityIndicator.color = UIColor.red
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupErrorLabel() {
        view.addSubview(errorLabel)

        errorLabel.text = "Failed to load standings. Please try again."
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true // Initially hidden

        errorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    // MARK: Selectors & Gesture handling

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
    }
}

// MARK: Table View Setup

extension StandingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        switch displayedStandingType {
            case .driver:
                return driverStanding.count
            case .constructor:
                return constructorStanding.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StandingsCell", for: indexPath) as? StandingsCell else {
            fatalError("Custom cell error")
        }
        switch displayedStandingType {
            case .driver:
                cell.configureDriverCell(with: driverStanding[indexPath.row], maxPoints: highestPoints ?? 1)
            case .constructor:
                cell.configureConstuctorCell(with: constructorStanding[indexPath.row], maxPoints: constuctorHighestPoints ?? 1)
        }

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 64
    }
}

private enum DisplayedStandingType {
    case driver
    case constructor
}
