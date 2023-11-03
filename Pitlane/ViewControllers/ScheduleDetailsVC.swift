//
//  ScheduleDetailsVC.swift
//  Pitlane
//
//  Created by Adam Zapiór on 03/11/2023.
//

import SnapKit
import UIKit

class ScheduleDetailsVC: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Variables
    
    var race: RaceModel? // Przekazujemy tutaj model wyścigu
    
    // MARK: - UI Components
    
    var scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    var contentView: UIView = {
        let cv = UIView()
        return cv
    }()
    
    var headerImageView: UIView = {
        let header = UIView()
        return header
    }()
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    var label: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground

        setupScrollView()
        setupContentView()
        setupHeader()
        setupImageView()
    }
    
    private func setupScrollView() {
       view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupHeader() {
        scrollView.addSubview(headerImageView)
        
        headerImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        let headerImageViewBottom : NSLayoutConstraint!
        headerImageViewBottom = self.headerImageView.bottomAnchor.constraint(equalTo: self.contentView.topAnchor, constant: -20)
        headerImageViewBottom.priority = UILayoutPriority(rawValue: 900)
        headerImageViewBottom.isActive = true
    }
    
    private func setupImageView() {
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "schedule-header")
        imageView.contentMode = .scaleAspectFill
        headerImageView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(headerImageView.snp.leading)
            make.trailing.equalTo(headerImageView.snp.trailing)
            make.bottom.equalTo(headerImageView.snp.bottom)
        }

        let imageViewTopConstraint: NSLayoutConstraint!
        imageViewTopConstraint = self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor)
        imageViewTopConstraint.priority = UILayoutPriority(rawValue: 900)
        imageViewTopConstraint.isActive = true
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(200)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
        
        label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliq›ua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        ])
    }
}
