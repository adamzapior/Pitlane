//
//  F1BodyLabel.swift
//  F1 Stats
//
//  Created by Adam Zapiór on 18/12/2022.
//

import UIKit

class F1BodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure() //
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignnment: NSTextAlignment) { //Setup UI Label for being customizable
        super.init(frame: .zero)
        self.textAlignment = textAlignnment
        configure() //
    }
    
    
    private func configure(){
        textColor                 = .label
        font                      = UIFont.preferredFont(forTextStyle: .body) //
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor        = 0.9
        lineBreakMode             = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}



#Preview {
    F1BodyLabel()
}


