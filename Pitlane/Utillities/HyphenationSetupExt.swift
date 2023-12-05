//
//  HyphenationSetupExt.swift
//  Pitlane
//
//  Created by Adam Zapiór on 04/12/2023.
//

import Foundation
import UIKit

extension UILabel {
    func setupHyphenation() {
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.adjustsFontSizeToFitWidth = false
        self.allowsDefaultTighteningForTruncation = true
        if let text = self.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.hyphenationFactor = 0.7
            let attributedString = NSAttributedString(string: text,
                                                      attributes: [.paragraphStyle: paragraphStyle])
            self.attributedText = attributedString
        }
    }
}
