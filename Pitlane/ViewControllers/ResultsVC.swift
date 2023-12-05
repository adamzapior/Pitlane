//
//  WhatsNewVC.swift
//  F1 Stats
//
//  Created by Adam Zapiór on 31/10/2022.
//

import SnapKit
import UIKit

class ResultsVC: UIViewController {
    var repository: Repository
    
    private var raceResult: [RaceResultModel] = []
    private var qualifyingResult: [QualifyingResultModel] = []
    private var sprintResult: [SprintResultModel] = []
    
    let tableView = UITableView()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActivityIndicator()

        activityIndicator.startAnimating()
        
        Task {
            await getResults()
        }
    }
    
    // MARK: Networking & Data setup
    
    private func handleRaceResult() async throws {
        do {
            let raceResults = try await repository.getRaceResult().get()
            DispatchQueue.main.async {
                self.raceResult = raceResults
            }
        } catch {
            throw error
        }
    }

    private func handleQualifyingResult() async throws {
        do {
            let qualifyingResults = try await repository.getQualifyingResult().get()
            DispatchQueue.main.async {
                self.qualifyingResult = qualifyingResults
            }
        } catch {
            throw error
        }
    }

    private func handleSprintResult() async throws {
        do {
            let sprintResults = try await repository.getSprintResult().get()
            DispatchQueue.main.async {
                self.sprintResult = sprintResults
            }
        } catch {
            throw error
        }
    }
    
    private func getResults() async {
        do {
            try await withThrowingTaskGroup(of: Void.self, body: { group in
                group.addTask { try await self.handleRaceResult() }
                group.addTask { try await self.handleQualifyingResult() }
                group.addTask { try await self.handleSprintResult() }
                
                try await group.waitForAll()
            })
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.tableView.isHidden = false
            }
        } catch {
            print("Wystąpił nieoczekiwany błąd: \(error)")
            DispatchQueue.main.async {
                self.setupReloadButtonIfNeeded()
                self.activityIndicator.stopAnimating()
            }
        }
    }

    // MARK: UI Setup
    
    private func setupUI() {
        view.backgroundColor = UIColor.UI.background
        title = "Results"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.UI.background
        tableView.allowsSelection = true
        tableView.register(ResultCell.self, forCellReuseIdentifier: ResultCell.identifier)
        tableView.isHidden = true
        tableView.showsVerticalScrollIndicator = false
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
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

    func setupReloadButtonIfNeeded() {
        if reloadButton.superview == nil {
            view.addSubview(reloadButton)
            reloadButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        }
        reloadButton.isHidden = false
    }
    
    @objc private func tryRefresh() {
        reloadButton.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        Task {
            await getResults()
        }
    }
}

// MARK: TableView setup

extension ResultsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return raceResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultCell.identifier, for: indexPath) as? ResultCell else {
            fatalError("Custom cell error")
        }
                
        cell.configure(raceModel: raceResult[indexPath.row], qualifyingModel: qualifyingResult[indexPath.row])
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = ResultsDetailsVC()
        detailsVC.raceResult = raceResult[indexPath.row]
        detailsVC.qualifyingResult = qualifyingResult[indexPath.row]
        detailsVC.sprintResult = findSprintResult(forRace: raceResult[indexPath.row])

        navigationController?.pushViewController(detailsVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: didSelectRow Helper

extension ResultsVC {
    func findSprintResult(forRace race: RaceResultModel) -> SprintResultModel? {
        for sprint in sprintResult {
            if sprint.raceName == race.raceName {
                return sprint
            }
        }
        return nil
    }
}

enum ResultsState {
    case success(race: [RaceResultModel], qualifying: [QualifyingResultModel], sprint: [SprintResultModel])
    case failure(Error)
}
