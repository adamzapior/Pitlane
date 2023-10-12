//
//  F1TitleLabel.swift
//  F1 Stats
//
//  Created by Adam Zapiór on 18/12/2022.
//

import UIKit

class F1TitleLabel: UILabel {

    override init (frame: CGRect) {
        super.init (frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignnment: NSTextAlignment, fontSize: CGFloat) { //Setup UI Label for being customizable
        super.init(frame: .zero)
        self.textAlignment = textAlignnment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }
    
    
    private func configure(){
        textColor                 = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor        = 0.9
        lineBreakMode             = .byTruncatingTail // if text is too long, view show something like: "abcdef..."
        translatesAutoresizingMaskIntoConstraints = false
    }

}
