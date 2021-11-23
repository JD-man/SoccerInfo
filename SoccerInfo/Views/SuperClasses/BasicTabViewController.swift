//
//  BasicTabViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/23.
//

import UIKit
import RealmSwift
import SideMenu

class BasicTabViewController<T: EmbeddedObject>: UIViewController, UINavigationControllerDelegate {
    
    var league: League = .premierLeague
    var season: Int = 2021
    var data: [T] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        sideButtonConfig()
    }
    
    func viewConfig() { }
    
    func sideButtonConfig() {
        let sideButton = UIBarButtonItem(title: "Premier League",
                                         style: .plain,
                                         target: self,
                                         action: #selector(sideButtonClicked))
        
        sideButton.tintColor = .label
        navigationItem.leftBarButtonItem = sideButton
        
    }
    
    @objc func sideButtonClicked() {
        let storyboard = UIStoryboard(name: "Side", bundle: nil)
        let sideVC = storyboard.instantiateViewController(withIdentifier: "SideViewController") as! SideViewController
        let sideNav = SideMenuNavigationController(rootViewController: sideVC)
        
        let presentationStyle = SideMenuPresentationStyle.menuSlideIn
        presentationStyle.presentingScaleFactor = 0.95
        presentationStyle.presentingEndAlpha = 0.35
        
        sideNav.leftSide = true
        sideNav.menuWidth = view.bounds.width * 0.6
        sideNav.presentationStyle = presentationStyle
        sideNav.delegate = self
        
        present(sideNav, animated: true, completion: nil)
    }
}
