//
//  CellPrimaryTextLabel.swift
//  Pitlane
//
//  Created by Adam Zapiór on 18/11/2023.
//

import UIKit

class CellTextLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        maximumContentSizeCategory = .extraSmall
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(fontStyle: UIFont.TextStyle, fontWeight: UIFont.Weight, textColor: UIColor!, textAlignment: NSTextAlignment? = nil, maxContentSizeCategory: UIContentSizeCategory? = nil) {
        self.init(frame: .zero)
        self.font = UIFont.preferredFont(forTextStyle: fontStyle)
        self.textColor = textColor
        self.textAlignment = textAlignment ?? .natural
        self.maximumContentSizeCategory = maxContentSizeCategory ?? .accessibilityExtraExtraExtraLarge
    }

    private func configure() {
        adjustsFontForContentSizeCategory = true
//        adjustsFontSizeToFitWidth = false
        minimumScaleFactor = 0.5
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
    }
}
