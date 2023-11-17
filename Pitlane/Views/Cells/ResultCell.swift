//
//  ResultCell.swift
//  Pitlane
//
//  Created by Adam Zapiór on 10/11/2023.
//

import UIKit

class ResultCell: UITableViewCell {
    
    static let identifier = "ScheduleCell"

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        return view
    }()

    private let flagImage: UIImageView = {
        let flag = UIImageView()
        flag.layer.masksToBounds = true
        flag.layer.cornerRadius = 6
        return flag
    }()

    private let raceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private let circuitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .footnote).pointSize, weight: .regular)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .UI.secondaryText
        return label
    }()
    
    private let arrowImage: UIImageView = {
        let arrowImage = UIImageView()
        arrowImage.image = UIImage(systemName: "chevron.right")!
        return arrowImage
    }()
    
    private let poleImage: UIImageView = {
        let poleImage = UIImageView()
        poleImage.image = UIImage(systemName: "timer")!
        return poleImage
    }()
    
    private let winnerImage: UIImageView = {
        let winnerImage = UIImageView()
        winnerImage.image = UIImage(systemName: "flag.checkered")!
        return winnerImage
    }()
    
    private let poleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let winnerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    
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
//            make.leading.equalToSuperview().offset(18)
        }
        
        poleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(poleImage)
            make.leading.equalTo(circuitLabel.snp.leading)
//            make.leading.equalTo(poleImage.snp.trailing).offset(6)
        }
        
        winnerImage.snp.makeConstraints { make in
            make.top.equalTo(poleImage.snp.bottom).offset(6)
            make.centerX.equalTo(flagImage)
//            make.leading.equalToSuperview().offset(18)
        }
        
        winnerLabel.snp.makeConstraints { make in
            make.top.equalTo(poleLabel.snp.bottom).offset(6)
            make.leading.equalTo(circuitLabel.snp.leading)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(winnerLabel)
            make.trailing.equalToSuperview().offset(-18)
        }
    }

}
