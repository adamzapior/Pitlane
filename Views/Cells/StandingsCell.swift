//
//  StandingsCell.swift
//  F1 Stats
//
//  Created by Adam Zapiór on 18/12/2022.
//

import UIKit

class StandingsCell: UICollectionViewCell {
    
    static let reuseID = "StandingsCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "StandingsCell", bundle: nil)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
}
    
    
}
