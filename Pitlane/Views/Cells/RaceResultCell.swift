//
//  ResultDetailsCell.swift
//  Pitlane
//
//  Created by Adam Zapiór on 17/11/2023.
//

import UIKit

class RaceResultCell: UITableViewCell {
    static let identifier = "RaceResultDetailsCell"
    
    private let flagImage = FlagImageView(frame: .zero)
    
    private let positionLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .regular, textColor: .UI.secondaryText, textAlignment: .center)
    private let nameLabel = CellTextLabel(fontStyle: .body, fontWeight: .semibold, textColor: .UI.primaryText)
    
    private let teamLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .light, textColor: .UI.secondaryText)
    
    private let statusLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .regular, textColor: .UI.primaryText, textAlignment: .right)
    private let pointsLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .regular, textColor: .UI.secondaryText, textAlignment: .center)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        setupUI()
    }

    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: RaceResultDataModel) {
        positionLabel.text = model.position
        nameLabel.text = "\(model.driver.name) \(model.driver.surname)"
        pointsLabel.text = model.points
        teamLabel.text = model.constructor.name
        statusLabel.text = model.time?.time ?? model.status
        
        flagImage.image = CountryFlagProvider.shared.nationalityFlag(for: model.driver.nationality)
    }

    private func setupUI() {
        contentView.addSubview(positionLabel)
        contentView.addSubview(flagImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(teamLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(pointsLabel)

        positionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(6)
            make.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(28)
//            make.width.size.equalTo(28)
        }
        
        flagImage.snp.makeConstraints { make in
            make.leading.equalTo(positionLabel.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(28)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top).offset(12)
            make.leading.equalTo(flagImage.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(statusLabel.snp.leading).offset(-12)
            make.bottom.equalTo(teamLabel.snp.top).offset(-6)
        }

        teamLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.leading.equalTo(flagImage.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(statusLabel.snp.leading).offset(-12)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-12)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(pointsLabel.snp.leading).offset(-12)
            make.top.equalTo(nameLabel.snp.top)
            make.bottom.equalTo(teamLabel.snp.bottom)
            make.width.greaterThanOrEqualTo(50)

        }

        positionLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh + 2, for: .horizontal)
        nameLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh + 1, for: .horizontal)
//        statusLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)

        
        pointsLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-6)
            make.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(28)
        }
    }
}
