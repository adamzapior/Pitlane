//
//  StandingsCell.swift
//  F1 Stats
//
//  Created by Adam Zapiór on 18/12/2022.
//

import FlagKit
import SnapKit
import UIKit

//class StandingsCell: UITableViewCell {
//    static let identifier = "StandingsCell"
//        
//    private let flagImage = FlagImageView(frame: .zero)
//    private let bar = StandingsBarView(frame: .zero)
//    private let barBackground = UIView()
//    
//    private let positionLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .light, textColor: .UI.primaryText)
//    private let nameLabel = CellTextLabel(fontStyle: .body, fontWeight: .semibold, textColor: .UI.primaryText)
//    private let pointsLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .light, textColor: .UI.primaryText)
//    
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        setupUI()
//    }
//    
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func configureDriverCell(with model: DriverStandingModel, maxPoints: Int) {
//        positionLabel.text = model.position
//        nameLabel.text = "\(model.driver.name) \(model.driver.surname)"
//        pointsLabel.text = model.points
//        
//        flagImage.image = CountryFlagProvider.shared.nationalityFlag(for: model.driver.nationality)
//        
//        let maxPointsConverted = CGFloat(exactly: maxPoints)
//    
//        if let pointsInt = Int(model.points), let points = CGFloat(exactly: pointsInt) {
//            let ratio = points / maxPointsConverted!
//            adjustBarWidth(ratio: ratio)
//        } else {
//            adjustBarWidth(ratio: 0)
//        }
//    }
//    
//    func configureConstuctorCell(with model: ConstructorStandingModel, maxPoints: Int) {
//        positionLabel.text = model.position
//        nameLabel.text = model.constructor.name
//        pointsLabel.text = model.points
//        
//        flagImage.image = CountryFlagProvider.shared.nationalityFlag(for: model.constructor.nationality)
//        
//        let maxPointsConverted = CGFloat(exactly: maxPoints)
//    
//        if let pointsInt = Double(model.points), let points = CGFloat(exactly: pointsInt) {
//            let ratio = points / maxPointsConverted!
//            adjustBarWidth(ratio: ratio)
//        } else {
//            adjustBarWidth(ratio: 0)
//        }
//    }
//    
//    private func adjustBarWidth(ratio: CGFloat) {
//        var minRatio: CGFloat = 0.03
//        
//        if ratio == 0 {
//            minRatio = 0
//        }
//        
//        let adjustedRatio = max(ratio, minRatio)
//        
//        barBackground.addSubview(bar)
//        bar.snp.remakeConstraints { make in
//            make.left.top.bottom.equalToSuperview()
//            make.width.equalTo(barBackground).multipliedBy(adjustedRatio)
//        }
//        layoutIfNeeded()
//    }
//
//    private func setupUI() {
//        addSubview(positionLabel)
//        addSubview(nameLabel)
//        addSubview(pointsLabel)
//        addSubview(flagImage)
//        addSubview(barBackground)
//
//        positionLabel.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(12)
//            make.centerY.equalToSuperview()
//            make.width.size.equalTo(24)
//        }
//        
//        flagImage.snp.makeConstraints { make in
//            make.leading.equalTo(positionLabel.snp.trailing).offset(6)
//            make.centerY.equalToSuperview()
//            make.height.equalTo(24)
//            make.width.equalTo(28)
//        }
//
//        nameLabel.snp.makeConstraints { make in
//            make.leading.equalTo(flagImage.snp.trailing).offset(12)
//            make.bottom.equalTo(flagImage.snp.centerY).offset(2)
//        }
//
//        pointsLabel.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().offset(-12)
//            make.centerY.equalToSuperview()
//        }
//        
//        barBackground.snp.makeConstraints { make in
//            make.leading.equalTo(flagImage.snp.trailing).offset(12)
//            make.bottom.equalTo(flagImage.snp.centerY).offset(14)
//            make.trailing.equalToSuperview().offset(-64)
//            make.height.equalTo(4)
//        }
//    }
//}


class StandingsCell: UITableViewCell {
    static let identifier = "StandingsCell"

    private let flagImage = FlagImageView(frame: .zero)

    private let positionLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .regular, textColor: .UI.secondaryText, textAlignment: .center)
    private let nameLabel = CellTextLabel(fontStyle: .body, fontWeight: .semibold, textColor: .UI.primaryText)

    private let teamLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .light, textColor: .UI.secondaryText)

    private let pointsLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .regular, textColor: .UI.secondaryText, textAlignment: .center)
    
    private let racerLabelsStack: UIStackView = {
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

        func configureDriverCell(with model: DriverStandingModel) {
            positionLabel.text = model.position
            nameLabel.text = "\(model.driver.name) \(model.driver.surname)"
            pointsLabel.text = model.points
            teamLabel.text = model.constructors.name
    
            flagImage.image = CountryFlagProvider.shared.nationalityFlag(for: model.driver.nationality)
        }
    
    func configureConstuctorCell(with model: ConstructorStandingModel) {
            positionLabel.text = model.position
            nameLabel.text = model.constructor.name
            pointsLabel.text = model.points
            teamLabel.text = "\(model.constructor.driver1code!) / \(model.constructor.driver2code!)"
        
            flagImage.image = CountryFlagProvider.shared.nationalityFlag(for: model.constructor.nationality)
        }
    
    private func setupUI() {
        contentView.addSubview(positionLabel)
        contentView.addSubview(flagImage)
        contentView.addSubview(pointsLabel)
        contentView.addSubview(racerLabelsStack)

        racerLabelsStack.addArrangedSubview(nameLabel)
        racerLabelsStack.addArrangedSubview(teamLabel)

    
        positionLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(28)
        }
        

        flagImage.snp.makeConstraints { make in
            
            make.leading.equalTo(positionLabel.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 28, height: 24))
        }

        racerLabelsStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(flagImage.snp.trailing).offset(18)
            make.trailing.equalTo(pointsLabel.snp.leading).offset(-18)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        pointsLabel.snp.makeConstraints { make in
            make.leading.equalTo(racerLabelsStack.snp.trailing).offset(18)
            make.trailing.equalTo(contentView.snp.trailing).offset(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(28)
        }
     
        nameLabel.setContentHuggingPriority(.defaultHigh + 3, for: .vertical)
        teamLabel.setContentHuggingPriority(.defaultHigh + 2, for: .vertical)
        pointsLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

    }
}

