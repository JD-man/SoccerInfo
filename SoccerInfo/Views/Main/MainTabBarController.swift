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
        tabBar.tintColor = .label
        tabBar.backgroundColor = .systemBackground
    }
}
