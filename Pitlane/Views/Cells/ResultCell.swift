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
    
    private let arrowImage = ResultImageView(systemImage: "chevron.right", color: .UI.theme, textStyle: .title3, contentMode: .right)
    private let poleImage = ResultImageView(systemImage: "timer", color: .UI.secondaryText, textStyle: .callout)
    private let winnerImage = ResultImageView(systemImage: "flag.checkered", color: .UI.secondaryText, textStyle: .callout)
    
    private let raceLabel = CellTextLabel(fontStyle: .body, fontWeight: .semibold, textColor: .UI.primaryText)
    private let circuitLabel = CellTextLabel(fontStyle: .footnote, fontWeight: .regular, textColor: .UI.secondaryText)
    private let poleLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .regular, textColor: .UI.primaryText)
    private let winnerLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .regular, textColor: .UI.primaryText)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        adjustFlagImageSize()
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
    }
    
    private func setupUI() {
        contentView.addSubview(flagImage)
        contentView.addSubview(raceLabel)
        contentView.addSubview(circuitLabel)
        contentView.addSubview(arrowImage)
        contentView.addSubview(poleImage)
        contentView.addSubview(poleLabel)
        contentView.addSubview(winnerImage)
        contentView.addSubview(winnerLabel)
        
        raceLabel.setContentHuggingPriority(.defaultHigh + 3, for: .vertical)
        circuitLabel.setContentHuggingPriority(.defaultHigh + 3, for: .vertical)
        arrowImage.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        flagImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(18)
            make.size.equalTo(CGSize(width: 28, height: 24))
        }
        
        raceLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(12)
            make.leading.equalTo(flagImage.snp.trailing).offset(18)
            make.trailing.equalTo(arrowImage.snp.leading).offset(-18)
        }
        
        circuitLabel.snp.makeConstraints { make in
            make.top.equalTo(raceLabel.snp.bottom).offset(8)
            make.leading.equalTo(flagImage.snp.trailing).offset(18)
            make.trailing.equalTo(arrowImage.snp.leading).offset(-18)
        }
        
        arrowImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(circuitLabel.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-18)
//            make.width.lessThanOrEqualTo(16)
//            make.width.equalTo(12)
        }
        
        poleImage.snp.makeConstraints { make in
            make.top.equalTo(circuitLabel.snp.bottom).offset(10)
            make.centerX.equalTo(flagImage)
//            make.size.equalTo(CGSize(width: 18, height: 18))
        }
        
        poleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(poleImage)
            make.leading.equalTo(circuitLabel.snp.leading)
        }
        
        winnerImage.snp.makeConstraints { make in
            //            make.top.equalTo(poleImage.snp.bottom).offset(6)
            make.centerX.equalTo(flagImage)
            make.centerY.equalTo(winnerLabel)
//            make.size.equalTo(CGSize(width: 18, height: 18))
            //            make.bottom.equalTo(contentView.snp.bottom).offset(-6)
        }
        
        winnerLabel.snp.makeConstraints { make in
            //            make.centerY.equalTo(winnerImage)
            make.leading.equalTo(circuitLabel.snp.leading)
            make.top.equalTo(poleLabel.snp.bottom).offset(6)
            make.bottom.equalTo(contentView.snp.bottom).offset(-12)
        }
    }
    
    private func adjustFlagImageSize() {
        let categorySize = UIApplication.shared.preferredContentSizeCategory
        
        let size: CGSize
        switch categorySize {
        case .extraSmall:
            size = CGSize(width: 20, height: 16)
        case .small:
            size = CGSize(width: 22, height: 18)
        case .medium:
            size = CGSize(width: 24, height: 20)
        case .large:
            size = CGSize(width: 26, height: 22)
        case .extraLarge:
            size = CGSize(width: 28, height: 24)
        case .extraExtraLarge:
            size = CGSize(width: 30, height: 26)
        case .extraExtraExtraLarge:
            size = CGSize(width: 32, height: 28)
        case .accessibilityExtraExtraExtraLarge:
            size = CGSize(width: 42, height: 38)
        default:
            size = CGSize(width: 28, height: 24)
        }
        
        flagImage.snp.updateConstraints { make in
            make.size.equalTo(size)
        }
//        poleImage.snp.updateConstraints { make in
//            make.size.equalTo(size)
//        }
//        winnerImage.snp.updateConstraints { make in
//            make.size.equalTo(size)
//        }
        
        // If you are using a layout that requires manual layout updates, you can call this method
        self.layoutIfNeeded()
    }
}
