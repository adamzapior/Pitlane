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
    private let surnameLabel = CellTextLabel(fontStyle: .body, fontWeight: .semibold, textColor: .UI.primaryText)
    
    private let teamLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .light, textColor: .UI.secondaryText)
    
    private let statusLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .regular, textColor: .UI.primaryText)
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
        
        let driver = ""
        
        positionLabel.text = model.position
        nameLabel.text = model.driver.name
        surnameLabel.text = model.driver.surname
        pointsLabel.text = model.points
        teamLabel.text = model.constructor.name
        statusLabel.text = model.time?.time ?? model.status
        
        flagImage.image = CountryFlagProvider.shared.nationalityFlag(for: model.driver.nationality)
    }

    private func setupUI() {
        addSubview(positionLabel)
        addSubview(nameLabel)
        addSubview(surnameLabel)
        addSubview(pointsLabel)
        addSubview(flagImage)
        addSubview(teamLabel)
        addSubview(statusLabel)

        positionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(6)
            make.centerY.equalToSuperview()
            make.width.size.equalTo(28)
        }
        
        flagImage.snp.makeConstraints { make in
            make.leading.equalTo(positionLabel.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(28)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(flagImage.snp.trailing).offset(12)
            make.bottom.equalTo(flagImage.snp.centerY).offset(2)
        }

        surnameLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(4)
            make.bottom.equalTo(flagImage.snp.centerY).offset(2)
        }
        
        teamLabel.snp.makeConstraints { make in
            make.leading.equalTo(flagImage.snp.trailing).offset(12)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.trailing.equalTo(pointsLabel.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
        }

        pointsLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-6)
            make.centerY.equalToSuperview()
            make.width.size.equalTo(28)
        }
    }
}
