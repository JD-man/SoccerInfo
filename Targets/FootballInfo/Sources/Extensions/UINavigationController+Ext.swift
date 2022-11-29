//
//  UINavigationController+Ext.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import UIKit

extension UINavigationController {
  // TODO: - shared Item을 League에서 shared item으로 변경해야함
  func basicAppearenceConfig(/*with sharedItem: League*/) {
    navigationBar.prefersLargeTitles = true
    
    let scrollEdgeAppearence = UINavigationBarAppearance()
    scrollEdgeAppearence.configureWithTransparentBackground()
    scrollEdgeAppearence.titleTextAttributes = [.foregroundColor : UIColor.white]
    scrollEdgeAppearence.largeTitleTextAttributes = [.foregroundColor : UIColor.white]
    navigationBar.scrollEdgeAppearance = scrollEdgeAppearence
    
    let standardAppearence = UINavigationBarAppearance()
    standardAppearence.configureWithOpaqueBackground()
    //standardAppearence.backgroundColor = sharedItem.colors[0]
    standardAppearence.titleTextAttributes = [.foregroundColor : UIColor.white]
    navigationBar.standardAppearance = standardAppearence
  }
}

extension UIViewController {
  func tabbarViewControllerConfig(title: String, icon: String) {
    navigationItem.title = title
    navigationController?.basicAppearenceConfig()
    navigationController?.tabBarItem.image = UIImage(systemName: icon)
  }
}
