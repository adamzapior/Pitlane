//
//  ResultDetailsCell.swift
//  Pitlane
//
//  Created by Adam Zapiór on 17/11/2023.
//

import UIKit

class ResultDetailsCell: UITableViewCell {

    static let identifier = "ResultDetailsCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let positionLabel: UILabel = {
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
    
    private let teamLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let resultLabeL: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let pointsLabel: UILabel = {
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
            make.leading.equalTo(positionLabel.snp.trailing).offset(6)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(28)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(flagImage.snp.trailing).offset(18)
            make.bottom.equalTo(flagImage.snp.centerY).offset(2)
        }

        surnameLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(4)
            make.bottom.equalTo(flagImage.snp.centerY).offset(2)
        }

        pointsLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
}
