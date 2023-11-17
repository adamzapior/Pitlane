//
//  ResultsDetailsVC.swift
//  Pitlane
//
//  Created by Adam Zapiór on 17/11/2023.
//

import UIKit

class ResultsDetailsVC: UIViewController {
    
    var raceResult: RaceResultModel!
    var qualifyingResult: QualifyingResultModel!
    var sprintResult: SprintResultModel?
    
    private let tableView = UITableView()
    private let tableViewHeader = UIView()

    private var resultType = ["Race", "Q3", "Q2", "Q1"]
    private var displayedResultType: DisplayedResultType = .race
    private lazy var segmentedControl = UISegmentedControl(items: resultType)

    private let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    

    private func setupUI() {
        navigationItem.title = raceResult.raceName
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()

        
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.UI.background
        tableView.allowsSelection = false
        tableView.register(ResultDetailsCell.self, forCellReuseIdentifier: ResultDetailsCell.identifier)
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
        /// If there is a sprint result, insert the "Sprint" segment, otherwise, ensure it is removed
                if sprintResult != nil {
//                    if !segmentedControl.containsSegment(withTitle: "Sprint") {
                        segmentedControl.insertSegment(withTitle: "Sprint", at: 1, animated: false)
//                    }
                } else {
                    let sprintIndex = resultType.firstIndex(of: "Sprint")
                    if let index = sprintIndex {
                        segmentedControl.removeSegment(at: index, animated: false)
                        resultType.remove(at: index) // Remove "Sprint" from the displayedResultType
                    }
                }
        
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
    
    // MARK: Selectors & Gesture handling
    
    @objc private func standingTypeDidChange(_ segmentedControl: UISegmentedControl) {
        if let sprintIndex = resultType.firstIndex(of: "Sprint"), segmentedControl.selectedSegmentIndex == sprintIndex {
            displayedResultType = .sprint
        } else {
            switch segmentedControl.selectedSegmentIndex {
                case 0:
                    displayedResultType = .race
                case 1 where sprintResult == nil: // Adjust for missing "Sprint"
                    displayedResultType = .q3
                case 2:
                    displayedResultType = .q2
                case 3:
                    displayedResultType = .q1
                default:
                    break
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

extension ResultsDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch displayedResultType {
        case .race:
            return raceResult.results.count
        case .sprint:
            return sprintResult!.sprintResults.count
        case .q3:
            return qualifyingResult.qualifyingResults.count
        case .q2:
            return qualifyingResult.qualifyingResults.count
        case .q1:
            return qualifyingResult.qualifyingResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultDetailsCell.identifier, for: indexPath) as? ResultDetailsCell else {
            fatalError("Custom cell error")
        }
        
        
        
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 64
    }
}

private enum DisplayedResultType {
    case race
    case sprint
    case q3
    case q2
    case q1
}
