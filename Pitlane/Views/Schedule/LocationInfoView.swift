//
//  LocationInfoView.swift
//  Pitlane
//
//  Created by Adam Zapiór on 09/11/2023.
//

import UIKit
import FlagKit

class LocationInfoView: UIView {

    let flagImage = UIImageView()
    let locationNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: RaceModel) {
        print("Configuring LocationInfoView with model: \(model)")
        
        locationNameLabel.text = model.circuit.location.locality
        flagImage.image = CountryFlagProvider.shared.countryFlag(for: model.circuit.location.country)
    }
    
    private func setupUI() {
        backgroundColor = UIColor.UI.primaryContainer
        layer.cornerRadius = 10
        clipsToBounds = true
        
        setupFlagImage()
        setupLocationNameLabel()
    }
    
    private func setupFlagImage() {
        addSubview(flagImage)
        
        flagImage.layer.masksToBounds = true
        flagImage.layer.cornerRadius = 6
        
        flagImage.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(12)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 42, height: 36))
        }
    }
    
    private func setupLocationNameLabel() {
        addSubview(locationNameLabel)
        
        locationNameLabel.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .semibold)
        locationNameLabel.adjustsFontForContentSizeCategory = true
        locationNameLabel.textColor = .UI.primaryText
        
        locationNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(flagImage.snp.trailing).offset(18)
            make.centerY.equalTo(flagImage)
        }
    }
}
