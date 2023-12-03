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
    
    var qualifyingResultSorted: [QualifyingResultDataModel] = []
    
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
    
    // MARK: UI Setup
    
    private func setupUI() {
        title = "\(raceResult.raceName.replacingOccurrences(of: "Grand Prix", with: "GP"))"
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .red
        
        setupTableView()
        setupSegmentedControl()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.UI.background
        tableView.allowsSelection = false
        tableView.register(RaceResultCell.self, forCellReuseIdentifier: RaceResultCell.identifier)
        tableView.isHidden = false
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
        let sprintIndex = resultType.firstIndex(of: "Sprint") ?? resultType.count
        if sprintResult != nil && sprintIndex == resultType.count {
            segmentedControl.insertSegment(withTitle: "Sprint", at: 1, animated: false)
            resultType.insert("Sprint", at: 1)
        } else if sprintResult == nil && sprintIndex < resultType.count {
            segmentedControl.removeSegment(at: sprintIndex, animated: false)
            resultType.remove(at: sprintIndex)
        }
        
        tableViewHeader.addSubview(segmentedControl)

        segmentedControl.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().offset(-10)
        }

        segmentedControl.addTarget(self, action: #selector(resultTypeDidChange(_:)), for: .valueChanged)
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
    
    // MARK: Filter methods
    
    private func filterQualifyingResult(result: QualifyingResultModel, qualiSession: QualifyingResultType) -> [QualifyingResultDataModel] {
        var sortedResults: [QualifyingResultDataModel]
        
        switch qualiSession {
        case .q3:
            sortedResults = result.qualifyingResults
                .sorted(by: { first, second -> Bool in
                    let firstTime = first.q3 ?? first.q2 ?? first.q1
                    let secondTime = second.q3 ?? second.q2 ?? second.q1
                    return firstTime < secondTime
                })
        case .q2:
            sortedResults = result.qualifyingResults
                .sorted(by: { first, second -> Bool in
                    let firstTime = first.q2 ?? first.q1
                    let secondTime = second.q2 ?? second.q1
                    return firstTime < secondTime
                })
        case .q1:
            sortedResults = result.qualifyingResults
                .sorted { $0.q1 < $1.q1 }
        }
        
        return sortedResults.enumerated().map { index, model -> QualifyingResultDataModel in
            var updatedModel = model
            updatedModel.position = "\(index + 1)" // Ustawienie pozycji zaczynając od 1
            return updatedModel
        }
    }

    // MARK: Selectors & Gesture handling
    
    @objc private func resultTypeDidChange(_ segmentedControl: UISegmentedControl) {
        let selectedSegmentTitle = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)

           switch selectedSegmentTitle {
           case "Sprint":
               displayedResultType = .sprint
           case "Race":
               displayedResultType = .race
           case "Q3":
               qualifyingResultSorted = filterQualifyingResult(result: qualifyingResult, qualiSession: .q3)
               displayedResultType = .q3
           case "Q2":
               qualifyingResultSorted = filterQualifyingResult(result: qualifyingResult, qualiSession: .q2)
               displayedResultType = .q2
           case "Q1":
               qualifyingResultSorted = filterQualifyingResult(result: qualifyingResult, qualiSession: .q1)
               displayedResultType = .q1
           default:
               break
           }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ResultsDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        switch displayedResultType {
        case .race:
            return raceResult.results.count
        case .sprint:
            return sprintResult!.sprintResults.count
        case .q3, .q2, .q1:
            return qualifyingResult.qualifyingResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RaceResultCell.identifier, for: indexPath) as? RaceResultCell else {
            fatalError("Custom cell error")
        }
        
        switch displayedResultType {
        case .race:
            let resultData = raceResult.results[indexPath.row]
            cell.configureRaceData(with: resultData)
        case .sprint:
            guard let sprintData = sprintResult?.sprintResults[indexPath.row] else {
                fatalError("No sprint data available")
            }
            cell.configureSprintData(with: sprintData)
        case .q3:
            let qualifyingData = qualifyingResultSorted[indexPath.row]
            cell.configureWithQualifyingResult(with: qualifyingData, session: .q3)
        case .q2:
            let qualifyingData = qualifyingResultSorted[indexPath.row]
            cell.configureWithQualifyingResult(with: qualifyingData, session: .q2)
        case .q1:
            let qualifyingData = qualifyingResultSorted[indexPath.row]
            cell.configureWithQualifyingResult(with: qualifyingData, session: .q1)
        }
           
        return cell
    }
        
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

private enum DisplayedResultType {
    case race
    case sprint
    case q3
    case q2
    case q1
}

enum QualifyingResultType {
    case q3
    case q2
    case q1
}

extension Array {
    func partitioned(by belongsInFirstGroup: (Element) -> Bool) -> ([Element], [Element]) {
        var firstGroup: [Element] = []
        var secondGroup: [Element] = []
        for element in self {
            if belongsInFirstGroup(element) {
                firstGroup.append(element)
            } else {
                secondGroup.append(element)
            }
        }
        return (firstGroup, secondGroup)
    }
}
