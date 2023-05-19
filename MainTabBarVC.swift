//
//  MainTabBarVC.swift
//  F1 Stats
//
//  Created by Adam Zapiór on 31/10/2022.
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // MARK: View Setup
        let vc1 = UINavigationController(rootViewController: MainVC())
        let vc2 = UINavigationController(rootViewController: WhatsNewVC())
        
        // MARK: Tab Bar Icons
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "house")

        
        // MARK: Tab Bar Title
        
        vc1.title = "Stats"
        vc2.title = "What's new?"
        
        // MARK: Tab Bar Color
        
        self.tabBar.tintColor = .label
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .red
        
        
        // MARK: - Set up in the VIEW CONTROLLER
        
        setViewControllers([vc1, vc2], animated: true)
    }
    


}
