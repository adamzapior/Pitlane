//
//  QualifyingResultCell.swift
//  Pitlane
//
//  Created by Adam Zapiór on 18/11/2023.
//

import UIKit

class QualifyingResultCell: UITableViewCell {
    
    static let identifier = "QualifyingResultCell"
    
    private let flagImage = FlagImageView(frame: .zero)
    
    private let positionLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .light, textColor: .UI.primaryText)
    private let nameLabel = CellTextLabel(fontStyle: .body, fontWeight: .regular, textColor: .UI.primaryText)
    private let surnameLabel = CellTextLabel(fontStyle: .body, fontWeight: .regular, textColor: .UI.primaryText)
    
    private let teamLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .light, textColor: .UI.primaryText)
    
    private let raceResultLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .light, textColor: .UI.primaryText)
    private let pointsLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .light, textColor: .UI.primaryText)
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func setupUI() {
        addSubview(positionLabel)
        addSubview(nameLabel)
        addSubview(surnameLabel)
        addSubview(pointsLabel)
        addSubview(flagImage)

        positionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(22)
            make.centerY.equalToSuperview()
            make.width.size.equalTo(24)
        }
        
        flagImage.snp.makeConstraints { make in
            make.leading.equalTo(positionLabel.snp.trailing).offset(6)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(28)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(flagImage.snp.trailing).offset(18)
            make.bottom.equalTo(flagImage.snp.centerY).offset(2)
        }

        surnameLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(4)
            make.bottom.equalTo(flagImage.snp.centerY).offset(2)
        }

        pointsLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-22)
            make.centerY.equalToSuperview()
        }
    }
}
