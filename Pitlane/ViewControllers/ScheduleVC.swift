//
//  MainVC.swift
//  F1 Stats
//
//  Created by Adam Zapiór on 31/10/2022.
//

import SnapKit
import UIKit

class ScheduleVC: UIViewController {
    var vm = ScheduleVM()
    
    private let tableView = UITableView()
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.delegate = self
        
        setupTableView()
        setupUI()
        
        Task {
            await vm.fetchSchedule()
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.allowsSelection = true
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.identifier)
        tableView.isHidden = true
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Schedule"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: Table View Setup

extension ScheduleVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return ScheduleType.allCases.count
    }
    
    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        let scheduleType = ScheduleType.allCases[section]
        switch scheduleType {
        case .future:
            return "Future Races"
        case .past:
            return "Past Races"
        }
    }
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let scheduleType = ScheduleType.allCases[section]
        switch scheduleType {
        case .future:
            return vm.futureRaces.count
        case .past:
            return vm.pastRaces.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as? ScheduleCell else {
            fatalError("Custom cell error")
        }
        
        let scheduleType = ScheduleType.allCases[indexPath.section]
        switch scheduleType {
        case .future:
            cell.configure(with: vm.futureRaces[indexPath.row], type: .future)
        case .past:
            cell.configure(with: vm.pastRaces[indexPath.row], type: .past)
        }
                
        return cell
    }
    
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scheduleType = ScheduleType.allCases[indexPath.section]
        let race: RaceModel

        switch scheduleType {
        case .future:
            race = vm.futureRaces[indexPath.row]
        case .past:
            race = vm.pastRaces[indexPath.row]
        }
        
        let detailsVC = ScheduleDetailsVC()
        detailsVC.race = race
        
        navigationController?.pushViewController(detailsVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 64
    }
}

extension ScheduleVC: ScheduleVMDelegate {
    func scheduleDidUpdate(_ viewModel: ScheduleVM, schedule _: [RaceModel]) {
        print("Data loaded")
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
        
        for raceSchedule in viewModel.raceSchedule {
            print(raceSchedule.raceName)
            print(raceSchedule.date)
        }
        
        for futureRace in viewModel.futureRaces {
            print(futureRace.date)
        }
    }
}

private enum ScheduleType: CaseIterable {
    case future
    case past
}
