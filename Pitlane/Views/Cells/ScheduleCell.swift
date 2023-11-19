//
//  ScheduleCell.swift
//  Pitlane
//
//  Created by Adam Zapiór on 27/10/2023.
//

import FlagKit
import UIKit

class ScheduleCell: UITableViewCell {
    static let identifier = "ScheduleCell"

    var cellType: CellType = .future

    private let flagImage = FlagImageView(frame: .zero)

    private let raceLabel = CellTextLabel(fontStyle: .body, fontWeight: .semibold, textColor: .UI.primaryText)
    private let circuitLabel = CellTextLabel(fontStyle: .footnote, fontWeight: .regular, textColor: .UI.secondaryText, maxContentSizeCategory: .accessibilityExtraLarge)
    private let dateLabel = CellTextLabel(fontStyle: .footnote, fontWeight: .light, textColor: .UI.primaryText, textAlignment: .right, maxContentSizeCategory: .accessibilityLarge)

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        switch cellType {
        case .future:
            layer.opacity = 1.0
        case .past:
            layer.opacity = 0.5
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    func configure(with model: ScheduleModel, type: CellType) {
        cellType = type
        raceLabel.text = model.raceName
        circuitLabel.text = "\(model.round) - \(model.circuit.circuitName)"
        dateLabel.text = "\(model.date.convertDateToScheduleString()) - \(model.date.convertDateToScheduleString())"

        flagImage.image = CountryFlagProvider.shared.countryFlag(for: model.circuit.location.country)
    }

    private func setupUI() {
        contentView.addSubview(flagImage)
        contentView.addSubview(raceLabel)
        contentView.addSubview(circuitLabel)
        contentView.addSubview(dateLabel)

        flagImage.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(18)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 28, height: 24))
        }
        

        raceLabel.snp.makeConstraints { make in
            make.leading.equalTo(flagImage.snp.trailing).offset(18)
            make.trailing.equalTo(contentView.snp.trailing).offset(-18)
            make.top.equalTo(contentView.snp.top).offset(12)

        }

        circuitLabel.snp.makeConstraints { make in
            make.leading.equalTo(flagImage.snp.trailing).offset(18)
            make.trailing.equalTo(contentView.snp.trailing).offset(-18)
            make.top.equalTo(raceLabel.snp.bottom).offset(6)
//            make.trailing.lessThanOrEqualTo(dateLabel.snp.leading).offset(-8)
        }

//        dateLabel.snp.makeConstraints { make in
//            make.trailing.equalTo(contentView.snp.trailing).offset(-18)
//            make.top.equalTo(circuitLabel.snp.bottom).offset(4)
//            make.width.greaterThanOrEqualTo(128)
//            make.bottom.equalTo(contentView.snp.bottom).offset(-18)
//        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-18)
            make.top.equalTo(circuitLabel.snp.bottom).offset(6)
            make.bottom.equalTo(contentView.snp.bottom).offset(-12)
        }
    }
}

enum CellType {
    case future
    case past
}
