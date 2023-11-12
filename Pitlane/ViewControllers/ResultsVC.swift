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
    
    private var races: [RaceModel] = []
    
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
    
        Task {
            await getResults()
        }
    }
    
    // MARK: Networking & Data setup
    
    private func getResults() async {
        let result = await repository.getResults()
        switch result {
        case .success(let result):
            races = result
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.isHidden = false
                print("fiu fiu")
            }
            
            for race in races {
                print(race.raceName)
            }
            
            for race in races {
                race.results!.map { t in
//                    t.fastestLap?.lap
                    print(t.fastestLap?.lap)
                }
//                print(race.results.)
            }
            
        case .failure(let error):
            DispatchQueue.main.async {
                self.errorLabel.isHidden = false
                self.activityIndicator.stopAnimating()
            }
            
            print(error)
            print("failed")
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
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension ResultsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return races.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultCell.identifier, for: indexPath) as? ResultCell else {
            fatalError("Custom cell error")
        }
                
        cell.configure(with: races[indexPath.row])
                
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 128
    }
}
