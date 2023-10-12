//
//  MainCategoryButton.swift
//  F1 Stats
//
//  Created by Adam Zapiór on 31/10/2022.
//

import UIKit

class F1MainButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    
    
// MARK: - Customizable Button
    init(backgroundColor: UIColor, title: String) {
    super.init(frame: .zero)                   // Wcześniej definiowałem już frame, generalnie nie ma to aż tak dużego znaczenia.
    self.backgroundColor = backgroundColor     // I tak w View Controllerze będę nadawał buttonowi wielkość, tu określam jego asety - !! nie definiuje koloru, brak kodu ".kolor"
    self.setTitle(title, for: .normal)         // self. - przywołuje rzeczy z 1 linii po init(...)
    configure()
}

//by this you can use GFButton with custom backgroundColor (UIColor) and title (String)
//after init, init ask for private func configure() - function is private, we use it only in GFButton class

    

// MARK: - Button Setup
private func configure() {
    
    //ogbligatory for UI by code:
    translatesAutoresizingMaskIntoConstraints = false // turn off Autolayout
    
    layer.cornerRadius      = 10 // draw corner Radius
    titleLabel?.textColor   = .white // Text Color
    titleLabel?.font        = UIFont.preferredFont(forTextStyle: .subheadline) //dynamic type of font - app is responsible = user can use bigger text in iphone preferences.
}
}


