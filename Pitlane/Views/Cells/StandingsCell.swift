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
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let bar: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 6
        return view
    }()

    private let barBackground: UIView = {
        let view = UIView()
        return view
    }()
    
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private let surnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private let pointsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let flagImage: UIImageView = {
        let flag = UIImageView()
        flag.layer.masksToBounds = true
        flag.layer.cornerRadius = 6
        return flag
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let countryMapping: [String: String] = [
        "Austrian": "AT",
        "Swiss": "CH",
        "British": "GB",
        "Mexican": "MX",
        "Spanish": "ES",
        "Monegasque": "MC",
        "Australian": "AU",
        "Canadian": "CA",
        "French": "FR",
        "Thai": "TH",
        "Finnish": "FI",
        "German": "DE",
        "Chinese": "CN",
        "Japanese": "JP",
        "Danish": "DK",
        "New Zealander": "NZ",
        "American": "US",
        "Dutch": "NL",
        "Italian": "IT",
    ]
    
    func configureDriverCell(with model: DriverStandingModel, maxPoints: Int) {
        positionLabel.text = model.position
        nameLabel.text = model.driver.givenName
        surnameLabel.text = model.driver.familyName
        pointsLabel.text = model.points
        
        if let countryCode = countryMapping[model.driver.nationality],
           let flag = Flag(countryCode: countryCode)
        {
            flagImage.image = flag.image(style: .none)
        } else {
            flagImage.image = nil
        }
        
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
        surnameLabel.text = ""
        pointsLabel.text = model.points
        
        if let countryCode = countryMapping[model.constructor.nationality],
           let flag = Flag(countryCode: countryCode)
        {
            flagImage.image = flag.image(style: .none)
        } else {
            flagImage.image = nil
        }
        
        let maxPointsConverted = CGFloat(exactly: maxPoints)
    
        if let pointsInt = Int(model.points), let points = CGFloat(exactly: pointsInt) {
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
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.bottom.equalToSuperview().offset(-32)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }
       
        containerView.addSubview(positionLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(surnameLabel)
        containerView.addSubview(pointsLabel)
        containerView.addSubview(flagImage)


        positionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.size.equalTo(24)
        }
        
        flagImage.snp.makeConstraints { make in
            make.leading.equalTo(positionLabel.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(flagImage.snp.trailing).offset(24)
            make.bottom.equalTo(flagImage.snp.centerY).offset(-2)
        }

        surnameLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(4)
            make.bottom.equalTo(flagImage.snp.centerY).offset(-2)
        }

        pointsLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        containerView.addSubview(barBackground)
        barBackground.snp.makeConstraints { make in
            make.leading.equalTo(flagImage.snp.trailing).offset(24)
            make.bottom.equalTo(flagImage.snp.centerY).offset(12)
            make.trailing.equalToSuperview().offset(-64)
            make.height.equalTo(4)
        }
    }
}
