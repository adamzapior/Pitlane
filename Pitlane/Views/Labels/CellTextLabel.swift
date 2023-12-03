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
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(fontStyle: UIFont.TextStyle, fontWeight: UIFont.Weight, textColor: UIColor!, textAlignment: NSTextAlignment? = nil) {
        self.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: fontStyle).pointSize, weight: fontWeight)
        self.textColor = textColor
        self.textAlignment = textAlignment ?? .natural
    }

    private func configure() {
        adjustsFontForContentSizeCategory = true
        minimumScaleFactor = 0.5
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
    }
}
