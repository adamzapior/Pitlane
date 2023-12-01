//
//  ResultDetailsCell.swift
//  Pitlane
//
//  Created by Adam Zapiór on 17/11/2023.
//

import SnapKit
import UIKit

class RaceResultCell: UITableViewCell {
    static let identifier = "RaceResultDetailsCell"

    private let flagImage = FlagImageView(frame: .zero)

    private let positionLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .regular, textColor: .UI.secondaryText, textAlignment: .center)
    private let nameLabel = CellTextLabel(fontStyle: .body, fontWeight: .semibold, textColor: .UI.primaryText)

    private let teamLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .light, textColor: .UI.secondaryText)

    private let statusLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .regular, textColor: .UI.primaryText)
    private let pointsLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .regular, textColor: .UI.secondaryText, textAlignment: .center)
    
    private let raceLabelStack: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 8
        sv.distribution = .fill
        sv.axis = .vertical
        return sv
    }()

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
        contentView.addSubview(pointsLabel)
        contentView.addSubview(raceLabelStack)

        raceLabelStack.addArrangedSubview(nameLabel)
        raceLabelStack.addArrangedSubview(teamLabel)
        raceLabelStack.addArrangedSubview(statusLabel)

    
        positionLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(28)
        }
        

        flagImage.snp.makeConstraints { make in
            
            make.leading.equalTo(positionLabel.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 28, height: 24))
            
            
//            make.leading.equalTo(contentView.snp.leading).offset(18)
//            make.centerY.equalToSuperview()
//            make.size.equalTo(CGSize(width: 28, height: 24))
        }

        raceLabelStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(flagImage.snp.trailing).offset(18)
            make.trailing.equalTo(pointsLabel.snp.leading).offset(-18)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        pointsLabel.snp.makeConstraints { make in
            make.leading.equalTo(raceLabelStack.snp.trailing).offset(18)
            make.trailing.equalTo(contentView.snp.trailing).offset(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(28)
        }
     
        nameLabel.setContentHuggingPriority(.defaultHigh + 3, for: .vertical)
        teamLabel.setContentHuggingPriority(.defaultHigh + 2, for: .vertical)
        statusLabel.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        pointsLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

    }
}

