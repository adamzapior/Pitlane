//
//  UIHelper.swift
//  F1 Stats
//
//  Created by Adam Zapiór on 19/12/2022.
//

import Foundation

import UIKit

struct UIHelper {
    
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        
        let width                        = view.bounds.width
        let padding: CGFloat             = 12
        let minimumItemSpacing: CGFloat  = 10
        let availableWidth               = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth                    = availableWidth / 1
        
        let flowLayout                   = UICollectionViewFlowLayout()
        flowLayout.sectionInset          = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize              = CGSize(width: itemWidth, height: itemWidth + 40)
        
        
        return flowLayout
    }
    
}
