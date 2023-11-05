//
//  ScheduleInfoLabel.swift
//  Pitlane
//
//  Created by Adam Zapiór on 04/11/2023.
//

import Foundation
import SnapKit
import UIKit

class ScheduleInfoView: UIView {
    // MARK: - UI Components

    private let titleTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .footnote).pointSize, weight: .regular)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .UI.secondaryText
        return label
    }()
    
    private let valueTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .semibold)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .UI.primaryText
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI Setup
    
    func configureText(titleText: String, valueText: String) {
        titleTextLabel.text = titleText
        valueTextLabel.text = valueText
    }
    
    private func setupUI() {
        backgroundColor = UIColor.UI.primaryContainer
        layer.cornerRadius = 10
        clipsToBounds = true
        
        setupTitleText()
        setupValueText()
    }
    
    private func setupTitleText() {
        addSubview(titleTextLabel)
        
        titleTextLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(12)
            make.leading.equalTo(self.snp.leading).offset(12)
            make.trailing.equalTo(self.snp.trailing).offset(-12)
        }
    }
    
    private func setupValueText() {
        addSubview(valueTextLabel)
        
        valueTextLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextLabel.snp.bottom).offset(8)
            make.leading.equalTo(self.snp.leading).offset(12)
            make.trailing.equalTo(self.snp.trailing).offset(-12)
            make.bottom.equalTo(self.snp.bottom).offset(-12)
        }
    }
}
