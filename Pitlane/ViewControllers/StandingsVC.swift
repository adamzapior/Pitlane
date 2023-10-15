import Foundation
import SnapKit
import UIKit

class StandingsVC: UIViewController {
    var vm = StandingsVM()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()

    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let activityIndicator = UIActivityIndicatorView()
    //    = {
    //        let indicator = UIActivityIndicatorView(style: .large)
    //        indicator.color = .red
    ////        indicator.translatesAutoresizingMaskIntoConstraints = false
    //        return indicator
    //    }
    //    ()
    
    private let segmentedControl: UISegmentedControl = {
        let standingType = ["Drivers", "Constructors"]
        let sc = UISegmentedControl(items: standingType)
        return sc
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.allowsSelection = true
        tableView.register(StandingsCell.self, forCellReuseIdentifier: StandingsCell.identifier)
        tableView.isHidden = true
        
        return tableView
    }()
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        setupActivityIndicator()
        activityIndicator.startAnimating()
        
        setupUI()

        Task {
            await vm.fetchStandings()
        }
        
        title = "Standings"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: UI Setup
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        setupStandingsTypeControl()
        containerView.addSubview(tableView)
        containerView.addSubview(activityIndicator)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        activityIndicator.style = .large
        activityIndicator.color = UIColor.red
    }
    
    private func setupStandingsTypeControl() {
//        let standingType = ["Drivers", "Constructors"]
//        let segmentedControl = UISegmentedControl(items: standingType)
        segmentedControl.addTarget(self, action: #selector(standingTypeDidChange(_:)), for: .valueChanged)
        
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10) // zakładając, że chcesz go blisko górnej krawędzi, ale z małym odstępem
            make.left.equalToSuperview().offset(10) // dodaj odstęp od lewej krawędzi
            make.right.equalToSuperview().offset(-10) // dodaj odstęp od prawej krawędzi
        }
    }
    
    @objc private func standingTypeDidChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: break
        case 1: break
        default: 0
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
//        tableView.reloadData()

        for standing in vm.standings {
            print(standing.season)
        }

        for driverStanding in vm.driverStandings {
            print(driverStanding.driver.familyName)
        }
    }

    func standingsDidFailToUpdate(_: StandingsVM, error _: Error) {
        print("Failed to load")
    }

    func driverStandingsDidUpdate(_: StandingsVM, driverStandings _: [DriverStandingModel]) {
//        for driverStanding in viewModel.driverStandings {
//            print(driverStanding.driver.familyName)
//        }
    }
}
