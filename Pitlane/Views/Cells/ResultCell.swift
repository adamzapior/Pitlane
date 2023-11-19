//
//  ResultCell.swift
//  Pitlane
//
//  Created by Adam Zapiór on 10/11/2023.
//

import UIKit

class ResultCell: UITableViewCell {
    static let identifier = "ScheduleCell"

    private let flagImage = FlagImageView(frame: .zero)

    private let arrowImage = ResultImageView(systemImage: "chevron.right", color: .UI.theme)
    private let poleImage = ResultImageView(systemImage: "timer", color: .UI.secondaryText)
    private let winnerImage = ResultImageView(systemImage: "flag.checkered", color: .UI.secondaryText)

    private let raceLabel = CellTextLabel(fontStyle: .body, fontWeight: .semibold, textColor: .UI.primaryText)
    private let circuitLabel = CellTextLabel(fontStyle: .footnote, fontWeight: .regular, textColor: .UI.secondaryText)
    private let poleLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .regular, textColor: .UI.primaryText)
    private let winnerLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .regular, textColor: .UI.primaryText)
    private let dateLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .regular, textColor: .UI.primaryText)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(raceModel: RaceResultModel, qualifyingModel: QualifyingResultModel) {
        flagImage.image = CountryFlagProvider.shared.countryFlag(for: raceModel.circuit.location.country)

        raceLabel.text = raceModel.raceName
        circuitLabel.text = "\(raceModel.round) - \(raceModel.circuit.circuitName)"
        poleLabel.text = qualifyingModel.qualifyingResults[0].driver.surname
        winnerLabel.text = raceModel.results[0].driver.surname
        dateLabel.text = raceModel.date.convertDateToScheduleString()
    }

    private func setupUI() {
        addSubview(flagImage)
        addSubview(raceLabel)
        addSubview(circuitLabel)
        addSubview(arrowImage)
        addSubview(poleImage)
        addSubview(poleLabel)
        addSubview(winnerImage)
        addSubview(winnerLabel)
        addSubview(dateLabel)

        flagImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(18)
            make.size.equalTo(CGSize(width: 28, height: 24))
        }

        raceLabel.snp.makeConstraints { make in
            make.leading.equalTo(flagImage.snp.trailing).offset(18)
            make.bottom.equalTo(flagImage.snp.centerY).offset(2)
        }

        circuitLabel.snp.makeConstraints { make in
            make.leading.equalTo(flagImage.snp.trailing).offset(18)
            make.bottom.equalTo(flagImage.snp.centerY).offset(22)
        }

        arrowImage.snp.makeConstraints { make in
            make.centerY.equalTo(flagImage.snp.centerY)
            make.trailing.equalToSuperview().offset(-18)
        }

        poleImage.snp.makeConstraints { make in
            make.top.equalTo(circuitLabel.snp.bottom).offset(10)
            make.centerX.equalTo(flagImage)
        }

        poleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(poleImage)
            make.leading.equalTo(circuitLabel.snp.leading)
        }

        winnerImage.snp.makeConstraints { make in
            make.top.equalTo(poleImage.snp.bottom).offset(6)
            make.centerX.equalTo(flagImage)
        }

        winnerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(winnerImage)
            make.leading.equalTo(circuitLabel.snp.leading)
        }

        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(winnerLabel)
            make.trailing.equalToSuperview().offset(-18)
        }
    }
}
