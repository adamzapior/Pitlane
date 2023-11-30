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
    
    convenience init(systemImage: String, color: UIColor!, textStyle: UIFont.TextStyle,contentMode: UIView.ContentMode? = nil) {
        self.init(frame: .zero)
        self.image = UIImage(systemName: systemImage, withConfiguration: UIImage.SymbolConfiguration(textStyle: textStyle))
        self.tintColor = color
        self.contentMode = contentMode ?? .scaleToFill
    }
    
    private func configure() {
        tintColor = .UI.secondaryText
        clipsToBounds = true
    }
}
