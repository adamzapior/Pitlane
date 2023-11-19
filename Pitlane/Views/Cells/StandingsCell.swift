//
//  StandingsCell.swift
//  F1 Stats
//
//  Created by Adam Zapiór on 18/12/2022.
//

import FlagKit
import SnapKit
import UIKit

class StandingsCell: UITableViewCell {
    static let identifier = "StandingsCell"
        
    private let flagImage = FlagImageView(frame: .zero)
    private let bar = StandingsBarView(frame: .zero)
    private let barBackground = UIView()
    
    private let positionLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .light, textColor: .UI.primaryText)
    private let nameLabel = CellTextLabel(fontStyle: .body, fontWeight: .semibold, textColor: .UI.primaryText)
    private let pointsLabel = CellTextLabel(fontStyle: .subheadline, fontWeight: .light, textColor: .UI.primaryText)
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDriverCell(with model: DriverStandingModel, maxPoints: Int) {
        positionLabel.text = model.position
        nameLabel.text = "\(model.driver.name) \(model.driver.surname)"
        pointsLabel.text = model.points
        
        flagImage.image = CountryFlagProvider.shared.nationalityFlag(for: model.driver.nationality)
        
        let maxPointsConverted = CGFloat(exactly: maxPoints)
    
        if let pointsInt = Int(model.points), let points = CGFloat(exactly: pointsInt) {
            let ratio = points / maxPointsConverted!
            adjustBarWidth(ratio: ratio)
        } else {
            adjustBarWidth(ratio: 0)
        }
    }
    
    func configureConstuctorCell(with model: ConstructorStandingModel, maxPoints: Int) {
        positionLabel.text = model.position
        nameLabel.text = model.constructor.name
        pointsLabel.text = model.points
        
        flagImage.image = CountryFlagProvider.shared.nationalityFlag(for: model.constructor.nationality)
        
        let maxPointsConverted = CGFloat(exactly: maxPoints)
    
        if let pointsInt = Double(model.points), let points = CGFloat(exactly: pointsInt) {
            let ratio = points / maxPointsConverted!
            adjustBarWidth(ratio: ratio)
        } else {
            adjustBarWidth(ratio: 0)
        }
    }
    
    private func adjustBarWidth(ratio: CGFloat) {
        var minRatio: CGFloat = 0.03
        
        if ratio == 0 {
            minRatio = 0
        }
        
        let adjustedRatio = max(ratio, minRatio)
        
        barBackground.addSubview(bar)
        bar.snp.remakeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(barBackground).multipliedBy(adjustedRatio)
        }
        layoutIfNeeded()
    }

    private func setupUI() {
        addSubview(positionLabel)
        addSubview(nameLabel)
        addSubview(pointsLabel)
        addSubview(flagImage)
        addSubview(barBackground)

        positionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
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
            make.leading.equalTo(flagImage.snp.trailing).offset(12)
            make.bottom.equalTo(flagImage.snp.centerY).offset(2)
        }

        pointsLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
        
        barBackground.snp.makeConstraints { make in
            make.leading.equalTo(flagImage.snp.trailing).offset(12)
            make.bottom.equalTo(flagImage.snp.centerY).offset(14)
            make.trailing.equalToSuperview().offset(-64)
            make.height.equalTo(4)
        }
    }
}
