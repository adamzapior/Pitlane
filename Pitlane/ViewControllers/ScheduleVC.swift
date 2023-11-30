//
//  MainVC.swift
//  F1 Stats
//
//  Created by Adam Zapiór on 31/10/2022.
//

import SnapKit
import UIKit

class ScheduleVC: UIViewController {
    var repository: Repository
        
    private var raceSchedule: [ScheduleModel] = []
    private var futureRaces: [ScheduleModel] = []
    private var pastRaces: [ScheduleModel] = []
    
    private let tableView = UITableView()
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
                
        setupTableView()
        setupUI()
        
        activityIndicator.startAnimating()
        
        Task {
            await fetchSchedule()
        }
    }
    
    // MARK: Networking & Data setup
    
    func fetchSchedule() async {
        let result = await repository.getSchedule()
        switch result {
        case .success(let schedule):
            raceSchedule = schedule
            futureRaces = filterFutureSchedule(schedule: raceSchedule)
            pastRaces = filterPastSchedule(schedule: raceSchedule)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.tableView.isHidden = false
                self.errorLabel.isHidden = true
            }
            
        case .failure:
            DispatchQueue.main.async {
                self.errorLabel.isHidden = false
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func filterFutureSchedule(schedule: [ScheduleModel]) -> [ScheduleModel] {
        let today = Date()
        return schedule.filter { race in
            race.date >= today
        }
    }
    
    private func filterPastSchedule(schedule: [ScheduleModel]) -> [ScheduleModel] {
        let today = Date()
        let pastSchedule = schedule.filter { race in
            race.date < today
        }
        return pastSchedule.reversed()
    }
    
    // MARK: UI Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Schedule"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        setupActivityIndicator()
        setupErrorLabel()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.allowsSelection = true
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.identifier)
        tableView.isHidden = true
        tableView.showsVerticalScrollIndicator = false
        
//        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        tableView.estimatedRowHeight = 64.0
        tableView.rowHeight = UITableView.automaticDimension
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
            return futureRaces.isEmpty ? nil : "Future Races"
        case .past:
            return "Past Races"
        }
    }
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let scheduleType = ScheduleType.allCases[section]
        switch scheduleType {
        case .future:
            return futureRaces.count
        case .past:
            return pastRaces.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.identifier, for: indexPath) as? ScheduleCell else {
            fatalError("Custom cell error")
        }
        
        let scheduleType = ScheduleType.allCases[indexPath.section]
        switch scheduleType {
        case .future:
            cell.configure(with: futureRaces[indexPath.row], type: .future)
        case .past:
            cell.configure(with: pastRaces[indexPath.row], type: .past)
        }
                
        return cell
    }
    
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scheduleType = ScheduleType.allCases[indexPath.section]
        let race: ScheduleModel

        switch scheduleType {
        case .future:
            race = futureRaces[indexPath.row]
        case .past:
            race = pastRaces[indexPath.row]
        }
        
        let detailsVC = ScheduleDetailsVC()
        detailsVC.race = race
        
        navigationController?.pushViewController(detailsVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

//    func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
//        return 64.0
//    }
}

private enum ScheduleType: CaseIterable {
    case future
    case past
}
