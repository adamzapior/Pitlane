//
//  ScheduleCell.swift
//  Pitlane
//
//  Created by Adam Zapiór on 27/10/2023.
//

import FlagKit
import UIKit

class ScheduleCell: UITableViewCell {
    
    // MARK: - Variables
    
    static let identifier = "ScheduleCell"

    var cellType: CellType = .future
    
    let countryMapping: [String: String] = [
        "Bahrain": "BH",
        "Saudi Arabia": "SA",
        "Australia": "AU",
        "Azerbaijan": "AZ",
        "USA": "US",
        "Monaco": "MC",
        "Spain": "ES",
        "Canada": "CA",
        "Austria": "AT",
        "UK": "UK",
        "Hungary": "HU",
        "Belgium": "BE",
        "Netherlands": "NL",
        "Italy": "IT",
        "Singapore": "SG",
        "Japan": "JP",
        "Qatar": "QA",
        "Mexico": "MX",
        "Brazil": "BR",
        "United States": "US",
        "UAE": "AE",
    ]


    // MARK: - UI Components
    
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
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
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

    func configure(with model: RaceModel, type: CellType) {
        cellType = type
        raceLabel.text = model.raceName
        circuitLabel.text = "\(model.round) - \(model.circuit.circuitName)"
        dateLabel.text = formatDate(dateString: model.date)

        if let countryCode = countryMapping[model.circuit.location.country],
           let flag = Flag(countryCode: countryCode)
        {
            flagImage.image = flag.image(style: .none)
        } else {
            flagImage.image = nil
        }
    }

    private func formatDate(dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd MMM"
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            return outputFormatter.string(from: date).uppercased()
        } else {
            return ""
        }
    }

    private func setupUI() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
//            make.top.equalToSuperview().offset(32.VAdapted)
//            make.bottom.equalToSuperview().offset(-32.VAdapted)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }

        containerView.addSubview(flagImage)
        containerView.addSubview(raceLabel)
        containerView.addSubview(circuitLabel)
        containerView.addSubview(dateLabel)

        flagImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 28, height: 24))
//            make.size.equalTo([28, 24].HResized)
//            make.height.equalTo(24)
//            make.width.equalTo(28)
        }

        raceLabel.snp.makeConstraints { make in
            make.leading.equalTo(flagImage.snp.trailing).offset(18)
            make.bottom.equalTo(flagImage.snp.centerY).offset(2)
        }

        circuitLabel.snp.makeConstraints { make in
            make.leading.equalTo(flagImage.snp.trailing).offset(18)
            make.bottom.equalTo(flagImage.snp.centerY).offset(22)
        }

        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(circuitLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-18)
        }
    }
}

enum CellType {
    case future
    case past
}
