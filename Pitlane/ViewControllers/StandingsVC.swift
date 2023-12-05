import Foundation
import SnapKit
import UIKit

class StandingsVC: UIViewController {
    var repository: Repository

    private var driverStandings: [DriverStandingModel] = []
    private var constructorStandings: [ConstructorStandingModel] = []

    private var highestPoints: Int?
    private var constuctorHighestPoints: Int?

    private let tableView = UITableView()
    private let tableViewHeader = UIView()

    private let standingType = ["Drivers", "Constructors"]
    private var displayedStandingType: DisplayedStandingType = .driver
    private lazy var segmentedControl = UISegmentedControl(items: standingType)

    private let activityIndicator = UIActivityIndicatorView()
    lazy var reloadButton: ReloadButton = {
        let button = ReloadButton(color: .UI.theme, title: "Something gone wrong, try to reload", systemImageName: "arrow.clockwise")
        button.addTarget(self, action: #selector(tryRefresh), for: .touchUpInside)
        return button
    }()

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

        activityIndicator.startAnimating()

        Task {
            await fetchStandings()
        }
    }

    // MARK: Networking & Data setup

    private func fetchStandings() async {
        let standingsResult = await repository.getStandings()

        switch standingsResult {
            case let .success((fetchedDriverStandings, fetchedConstructorStandings)):
                driverStandings = fetchedDriverStandings
                constructorStandings = fetchedConstructorStandings

                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }

            case .failure:
                setupReloadButtonIfNeeded()
                activityIndicator.stopAnimating()
        }
    }

    // MARK: UI Setup

    private func setupUI() {
        navigationItem.title = "Standings"
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
        tableView.allowsSelection = false
        tableView.register(StandingsCell.self, forCellReuseIdentifier: StandingsCell.identifier)
        tableView.isHidden = true
        tableView.showsVerticalScrollIndicator = false

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

    private func setupReloadButtonIfNeeded() {
        if reloadButton.superview == nil {
            view.addSubview(reloadButton)
            reloadButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        }

        reloadButton.isHidden = false
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

    @objc private func tryRefresh() {
        reloadButton.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        Task {
            await fetchStandings()
        }
    }
}

// MARK: Table View Setup

extension StandingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        switch displayedStandingType {
            case .driver:
                return driverStandings.count
            case .constructor:
                return constructorStandings.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StandingsCell.identifier, for: indexPath) as? StandingsCell else {
            fatalError("Custom cell error")
        }
        switch displayedStandingType {
            case .driver:
                cell.configureDriverCell(with: driverStandings[indexPath.row])
            case .constructor:
                cell.configureConstuctorCell(with: constructorStandings[indexPath.row])
        }

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

private enum DisplayedStandingType {
    case driver
    case constructor
}
