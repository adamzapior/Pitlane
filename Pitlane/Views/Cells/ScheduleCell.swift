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
    private let arrowImage = ResultImageView(systemImage: "chevron.right", color: .UI.theme, textStyle: .title3)

    private let raceLabelStack: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 8
        sv.distribution = .fill
        sv.axis = .vertical
        return sv
    }()

    private let raceLabel = CellTextLabel(fontStyle: .body, fontWeight: .semibold, textColor: .UI.primaryText)
    private let circuitLabel = CellTextLabel(fontStyle: .footnote, fontWeight: .regular, textColor: .UI.secondaryText)
    private let dateLabel = CellTextLabel(fontStyle: .footnote, fontWeight: .light, textColor: .UI.primaryText)

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
        dateLabel.text = "\(model.firstPractice.date.convertDateToScheduleString()) - \(model.date.convertDateToScheduleString())"

        flagImage.image = CountryFlagProvider.shared.countryFlag(for: model.circuit.location.country)
    }

    private func setupUI() {
        contentView.addSubview(flagImage)
        contentView.addSubview(arrowImage)
        contentView.addSubview(raceLabelStack)

        raceLabelStack.addArrangedSubview(raceLabel)
        raceLabelStack.addArrangedSubview(circuitLabel)
        raceLabelStack.addArrangedSubview(dateLabel)

    
        raceLabelStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(flagImage.snp.trailing).offset(18)
            make.trailing.equalTo(arrowImage.snp.leading).offset(-18)
            make.bottom.equalToSuperview().offset(-12)
        }

        flagImage.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(18)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 28, height: 24))
        }

        arrowImage.snp.makeConstraints { make in
            make.leading.equalTo(raceLabelStack.snp.trailing).offset(18)
            make.trailing.equalTo(contentView.snp.trailing).offset(-18)
            make.centerY.equalToSuperview()
            make.width.equalTo(12)
        }
        
        /// Content hugging helps to debug view hierarchy
        /// Visually, the cells look identical and support Dynamic Type in all sizes
        /// Same issue with automatic row height from StackOverFlow: https://stackoverflow.com/questions/68951886/ambiguous-uilabel-height-in-autoresizing-uitableviewcell
     
        raceLabel.setContentHuggingPriority(.defaultHigh + 3, for: .vertical)
        circuitLabel.setContentHuggingPriority(.defaultHigh + 2, for: .vertical)
        dateLabel.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)

    }
}

enum CellType {
    case future
    case past
}
