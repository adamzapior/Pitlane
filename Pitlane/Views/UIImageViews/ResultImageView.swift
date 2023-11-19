//
//  ResultImageView.swift
//  Pitlane
//
//  Created by Adam Zapiór on 18/11/2023.
//

import UIKit

class ResultImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(systemImage: String, color: UIColor!) {
        self.init(frame: .zero)
        self.image = UIImage(systemName: systemImage)
        self.tintColor = color
    }
    
    private func configure() {
        tintColor = .UI.secondaryText
    }
}
