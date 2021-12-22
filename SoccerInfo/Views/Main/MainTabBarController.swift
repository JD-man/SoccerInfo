//
//  MainTabBarController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/18.
//

import UIKit
import RealmSwift

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()        
    }
    
    func viewConfig() {
        if #available(iOS 15.0, *) {
            let tabbarAppearance = UITabBarAppearance()
            tabbarAppearance.configureWithOpaqueBackground()
            tabbarAppearance.backgroundColor = .black
            
            UITabBar.appearance().tintColor = .white
            UITabBar.appearance().standardAppearance = tabbarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabbarAppearance            
        }
        else {
            UITabBar.appearance().tintColor = .white
            UITabBar.appearance().barTintColor = .black
        }
    }
}
