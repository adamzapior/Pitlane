//
//  ScheduleTimetableView.swift
//  Pitlane
//
//  Created by Adam Zapiór on 05/11/2023.
//

import UIKit

class ScheduleTimetableView: UIView {
    
    let practice1Text: String
    
    let practive1View = TimetableItemView()
    let practive2View = TimetableItemView()
    let practice3View = TimetableItemView()
    let qualifiyingView = TimetableItemView()
    let raceView = TimetableItemView()
    
    
    init(practice1Text: String) {
        self.practice1Text = practice1Text
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.UI.primaryContainer
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    private func setupPractice1View() {
        
    }

}
