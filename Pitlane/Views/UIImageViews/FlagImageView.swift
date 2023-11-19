//
//  FlagImageView.swift
//  Pitlane
//
//  Created by Adam Zapiór on 18/11/2023.
//

import UIKit

class FlagImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius  = 6
        clipsToBounds       = true
    }
}
