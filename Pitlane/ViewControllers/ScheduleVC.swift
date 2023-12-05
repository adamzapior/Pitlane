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
    private let tableViewHeader = ScheduleHeaderView()
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
                self.setupTableViewHeader()
            }
            
        case .failure:
            DispatchQueue.main.async {
                self.setupReloadButtonIfNeeded()
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
        
        setupTableView()
        setupTableViewHeader()
        setupActivityIndicator()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.allowsSelection = true
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.identifier)
        tableView.isHidden = true
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
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

        
    private func setupTableViewHeader() {
        tableView.addSubview(tableViewHeader)
        tableViewHeader.backgroundColor = UIColor.UI.background
        tableView.tableHeaderView = tableViewHeader

        tableViewHeader.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(300)
        }
        
        if !futureRaces.isEmpty {
            tableViewHeader.configure(race: futureRaces.first!.raceName, circuit: futureRaces.first!.circuit.circuitName, date: "\(futureRaces.first!.firstPractice.date.convertDateToScheduleString()) - \(futureRaces.first!.date.convertDateToScheduleString())", location: futureRaces.first!.circuit.location.country)
        } else {
            tableViewHeader.configure(race: "Yes, I miss Formula One too", circuit: "Check out my other projects", date: "🙈🙉🐵", location: "")
        }
        
        let headerTapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        tableViewHeader.addGestureRecognizer(headerTapGesture)
        tableViewHeader.isUserInteractionEnabled = true
    }
    
    // MARK: Selector methods
    
    @objc private func headerTapped() {
        guard !futureRaces.isEmpty else { return }

        let race = futureRaces.first!

        let detailsVC = ScheduleDetailsVC()
        detailsVC.race = race
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    @objc private func tryRefresh() {
        reloadButton.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        Task {
            await fetchSchedule()
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
            return max(futureRaces.count - 1, 0)
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
            cell.configure(with: futureRaces[indexPath.row + 1], type: .future)
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
}

private enum ScheduleType: CaseIterable {
    case future
    case past
}
