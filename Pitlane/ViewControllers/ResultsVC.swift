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
    
    private func getResults() async {
        async let getRaceResult: NetworkResult<[RaceResultModel]> = repository.getRaceResult()
        async let getQualifyingResult: NetworkResult<[QualifyingResultModel]> = repository.getQualifyingResult()
        async let getSprintResult: NetworkResult<[SprintResultModel]> = repository.getSprintResult()
        
        let raceResult = await getRaceResult
        let qualifyingResult = await getQualifyingResult
        let sprintResult = await getSprintResult
        
        switch (raceResult, qualifyingResult, sprintResult) {
        case let (.success(raceResult), .success(qualifyingResult), .success(sprintResult)):
            self.raceResult = raceResult
            self.qualifyingResult = qualifyingResult
            self.sprintResult = sprintResult

            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.isHidden = false
                self.errorLabel.isHidden = true
                self.tableView.reloadData()
            }
            
        case (.failure(_), _, _):
            print("Error fetching race result")
            updateUIForError()
        case (_, .failure(_), _):
            print("Error fetching qualifying result")
            updateUIForError()
        case (_, _, .failure(_)):
            print("Error fetching sprint result")
            updateUIForError()
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
        title = "Result"
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
        
        navigationController?.pushViewController(detailsVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 128
    }
}
