//
//  ScheduleHeaderView.swift
//  Pitlane
//
//  Created by Adam Zapiór on 03/12/2023.
//

import UIKit

class ScheduleHeaderView: UIView {
    let imageView = UIImageView()
    let infoView = UIView()
    
    private var flagImage = FlagImageView(frame: .zero)
    private let arrowImage = ResultImageView(systemImage: "chevron.right", color: .UI.theme, textStyle: .title3)

    private let raceLabelsStack: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 8
        sv.distribution = .fill
        sv.axis = .vertical
        return sv
    }()

    private let raceLabel = CellTextLabel(fontStyle: .body, fontWeight: .semibold, textColor: .UI.primaryText)
    private let circuitLabel = CellTextLabel(fontStyle: .footnote, fontWeight: .regular, textColor: .UI.secondaryText)
    private let dateLabel = CellTextLabel(fontStyle: .footnote, fontWeight: .light, textColor: .UI.primaryText)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageView()
        setupInfoView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupImageView()
        setupInfoView()
    }
    
    func configure(race: String, circuit: String, date: String, location: String) {
        raceLabel.text = race
        circuitLabel.text = circuit
        dateLabel.text = date
        flagImage.image = CountryFlagProvider.shared.countryFlag(for: location)
        
        raceLabel.setupHyphenation()
        circuitLabel.setupHyphenation()
    }
    
    private func setupImageView() {
        imageView.image = UIImage(named: "schedule-header")
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    private func setupInfoView() {
        infoView.backgroundColor = .UI.primaryContainer!.withAlphaComponent(0.9)
        addSubview(infoView)
        
        infoView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(100)
        }
        
        infoView.addSubview(flagImage)
        infoView.addSubview(raceLabelsStack)
        
        flagImage.snp.makeConstraints { make in
            make.leading.equalTo(infoView.snp.leading).offset(18)
            make.centerY.equalTo(infoView)
            make.size.equalTo(CGSize(width: 28, height: 24))
        }
        
        raceLabelsStack.snp.makeConstraints { make in
            make.top.equalTo(infoView).offset(12)
            make.leading.equalTo(flagImage.snp.trailing).offset(18)
            make.trailing.equalTo(infoView.snp.trailing).offset(-18)
            make.bottom.equalTo(infoView).offset(-12)
        }
        
        raceLabelsStack.addArrangedSubview(raceLabel)
        raceLabelsStack.addArrangedSubview(circuitLabel)
        raceLabelsStack.addArrangedSubview(dateLabel)
    }
}
