//
//  WhatsNewVC.swift
//  F1 Stats
//
//  Created by Adam Zapiór on 31/10/2022.
//

import UIKit

class ResultsVC: UIViewController {
    
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
/*
        // Add the table view to the view hierarchy and set its constraints
                
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
   ///
        ///     // Set the table view's delegate and data source
        ///    tableView.delegate = self
        ///    tableView.dataSource = self
        
        ///     // Register a cell class or nib file for use in creating new table cells
       
        ///   tableView.register(F1TableViewCell.self, forCellReuseIdentifier: F1TableViewCell.reuseID)
        
        ///    tableView.backgroundColor = .red
        ///   view.addSubview(tableView)
*/
        
        
        
    }
}

