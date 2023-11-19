//
//  ResultDetailsTableHeaderView.swift
//  Pitlane
//
//  Created by Adam Zapiór on 18/11/2023.
//

import UIKit

class ResultDetailsTableHeaderView: UIView {

    let lpLabel = CellTextLabel(fontStyle: .callout, fontWeight: .regular, textColor: .UI.secondaryText)
    let driverLabel = CellTextLabel(fontStyle: .callout, fontWeight: .regular, textColor: .UI.secondaryText)
    let resultLabel = CellTextLabel(fontStyle: .callout, fontWeight: .regular, textColor: .UI.secondaryText)
    let pointsLabel = CellTextLabel(fontStyle: .callout, fontWeight: .regular, textColor: .UI.secondaryText)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(lpLabel)
        addSubview(driverLabel)
        addSubview(resultLabel)
        addSubview(pointsLabel)
    }
    
    
    private func configureText() {
        lpLabel.text = "LP"
        driverLabel.text = "Driver"
        resultLabel.text = "Result"
        pointsLabel.text = "Pts"
    }
}
