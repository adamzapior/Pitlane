import Foundation
import SnapKit
import UIKit

class StandingsVC: UIViewController {
    var vm = StandingsVM()

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.style = .large
        ai.color = UIColor.red
        return ai
    }()

    private let tableViewHeader: TableViewHeader = {
        let view = TableViewHeader()
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

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        setupUI()
        activityIndicator.startAnimating()

        scrollViewDidScroll(tableView)

        Task {
            await vm.fetchStandings()
        }
    }

    // MARK: UI Setup

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            if tableView.contentOffset.y > 10.0 {
                navigationController?.navigationBar.prefersLargeTitles = false
            }

            if tableView.contentOffset.y <= 10.0 {
                navigationController?.navigationBar.prefersLargeTitles = true
                navigationItem.largeTitleDisplayMode = .automatic
                navigationController?.navigationBar.sizeToFit()
            }
        }
    }

    private func setupUI() {
        title = "Standings"
        view.backgroundColor = .systemBackground

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.sizeToFit()
        tableView.contentInsetAdjustmentBehavior = .never

        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        view.addSubview(tableView)
        tableView.tableHeaderView = tableViewHeader

        tableViewHeader.standingTypeChanged = { [weak self] segmentedControl in
            self?.standingTypeDidChange(segmentedControl)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }

    // MARK: Selectors

    @objc private func standingTypeDidChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: break
        case 1: break
        default: break
        }
    }
}

extension StandingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return vm.driverStandings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StandingsCell", for: indexPath) as? StandingsCell else {
            fatalError("Custom cell error")
        }
        cell.configure(with: vm.driverStandings[indexPath.row])
        return cell
    }
}

extension StandingsVC: StandingsVMDelegate {
    func standingsDidUpdate(_: StandingsVM, standings _: [DriverStandingModel]) {
        print("Data loaded")

        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
        }

        for driverStanding in vm.driverStandings {
            print(driverStanding.driver.familyName)
        }
    }

    func standingsDidFailToUpdate(_: StandingsVM, error _: Error) {
        print("Failed to load")
    }

    func driverStandingsDidUpdate(_: StandingsVM, driverStandings _: [DriverStandingModel]) {
        //
    }
}
