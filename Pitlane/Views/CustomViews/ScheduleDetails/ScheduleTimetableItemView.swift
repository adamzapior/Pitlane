//
//  SchedulePracticeInfoView.swift
//  Pitlane
//
//  Created by Adam Zapiór on 05/11/2023.
//

import UIKit

class ScheduleTimetableItemView: UIView {
    let practiceNameLabel = UILabel()
    let dateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(practiceNameText: String, dateText: String) {
        practiceNameLabel.text = practiceNameText
        dateLabel.text = dateText
        
        practiceNameLabel.setupHyphenation()
        dateLabel.setupHyphenation()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.UI.primaryContainer
        layer.cornerRadius = 10
        clipsToBounds = true
        
        setupPracticeNameLabel()
        setupDateLabel()
    }
    
    private func setupPracticeNameLabel() {
        addSubview(practiceNameLabel)
        
        practiceNameLabel.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .footnote).pointSize, weight: .regular)
        practiceNameLabel.adjustsFontForContentSizeCategory = true
        practiceNameLabel.textColor = .UI.secondaryText

        practiceNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(12)
            make.leading.equalTo(self.snp.leading).offset(12)
            make.trailing.equalTo(self.snp.trailing).offset(-12)
        }
    }
    
    private func setupDateLabel() {
        addSubview(dateLabel)
        
        dateLabel.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular)
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.textColor = .UI.primaryText
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(practiceNameLabel.snp.bottom).offset(8)
            make.leading.equalTo(self.snp.leading).offset(12)
            make.trailing.equalTo(self.snp.trailing).offset(-12)
            make.bottom.equalTo(self.snp.bottom).offset(-12)
        }
    }
}
