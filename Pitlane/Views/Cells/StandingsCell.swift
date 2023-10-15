//
//  StandingsCell.swift
//  F1 Stats
//
//  Created by Adam Zapiór on 18/12/2022.
//

import UIKit

class StandingsCell: UITableViewCell {
    static let identifier = "StandingsCell"

    private let positionLabel: UILabel = {
        let label = UILabel()

        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let surnameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let pointsLabel: UILabel = {
        let label = UILabel()

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
    
    func configure(with model: DriverStandingModel) {
        positionLabel.text = model.position
        nameLabel.text = model.driver.givenName
        surnameLabel.text = model.driver.familyName
        pointsLabel.text = model.points
    }

    private func setupUI() {
        addSubview(positionLabel)
        addSubview(nameLabel)
        addSubview(surnameLabel)
        addSubview(pointsLabel)

        let spacing: CGFloat = 8

        positionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(spacing)
            make.centerY.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(positionLabel.snp.trailing).offset(spacing)
            make.centerY.equalToSuperview()
        }

        surnameLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(spacing)
            make.centerY.equalToSuperview()
        }

        pointsLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-spacing)
            make.centerY.equalToSuperview()
        }
    }

   
}
