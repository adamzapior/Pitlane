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
    private let errorLabel = UILabel()
    
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
        setupErrorLabel()

        activityIndicator.startAnimating()
        
        Task {
            await getResults()
        }
    }
    
    // MARK: Networking & Data setup
    
    private func handleRaceResult() async throws {
        do {
            let raceResults = try await self.repository.getRaceResult().get()
            DispatchQueue.main.async {
                self.raceResult = raceResults
            }
        } catch {
            throw error
        }
    }

    private func handleQualifyingResult() async throws {
        do {
            let qualifyingResults = try await self.repository.getQualifyingResult().get()
            DispatchQueue.main.async {
                self.qualifyingResult = qualifyingResults
            }
        } catch {
            throw error
        }
    }

    private func handleSprintResult() async throws {
        do {
            let sprintResults = try await self.repository.getSprintResult().get()
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
            // Aktualizacja UI po pomyślnym pobraniu wszystkich wyników
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.errorLabel.isHidden = true
                self.tableView.isHidden = false
                
                for i in self.raceResult {
                    print(i.raceName)
                }
                
                for s in self.sprintResult {
                    print(s.raceName)
                }
            }
        } catch {
            print("Wystąpił nieoczekiwany błąd: \(error)")
            DispatchQueue.main.async {
                self.updateUIForError()
            }
        }
    }

    
    private func updateUIForError() {
        DispatchQueue.main.async {
            self.errorLabel.isHidden = false
            self.activityIndicator.stopAnimating()
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
    
//    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
//        return 128
//    }
    
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
    
//    func extractRaceResult(for model: RaceResultModel) -> [RaceResultDataModel] {
//        
//    }
//    return
}


enum ResultsState {
    case success(race: [RaceResultModel], qualifying: [QualifyingResultModel], sprint: [SprintResultModel])
    case failure(Error)
}
