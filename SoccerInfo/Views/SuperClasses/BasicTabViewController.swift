//
//  BasicTabViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/23.
//

import UIKit
import RealmSwift
import SideMenu
import SwiftUI

class BasicTabViewController<T: BasicTabViewData>: UIViewController, UINavigationControllerDelegate, SideMenuNavigationControllerDelegate {
    
    var data: [T] = []
    var season: Int = 2021
    var activityView = UIActivityIndicatorView()
    var gradient = CAGradientLayer()
    
    var league: League = .premierLeague {
        didSet {
            fetchData()
            changeBackgroundColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        sideButtonConfig()
        league = PublicPropertyManager.shared.league
    }
    
    func viewConfig() {
        view.backgroundColor = .systemBackground
        
        // activity view config
        activityView = activityIndicator()
        
        // gradient config
        gradient.frame = view.bounds
        gradient.startPoint = CGPoint(x: 0.5, y: 0.7)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradient, at: 0)
        
        navAppearenceConfig()
    }
    
    func sideButtonConfig() {
        let sideButton = UIBarButtonItem(title: "Premier League",
                                         style: .plain,
                                         target: self,
                                         action: #selector(sideButtonClicked))
        
        sideButton.tintColor = .link
        navigationItem.leftBarButtonItem = sideButton
    }
    
    @objc func sideButtonClicked() {
        let storyboard = UIStoryboard(name: "Side", bundle: nil)
        let sideVC = storyboard.instantiateViewController(withIdentifier: "SideViewController") as! SideViewController
        
        sideVC.selectedLeague = League(rawValue: navigationItem.leftBarButtonItem!.title!)!
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
    
    // for sharing league value whole tab
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if league != PublicPropertyManager.shared.league {
            league = PublicPropertyManager.shared.league
        }
    }
    
    // for sharing league value whole tab
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem?.title = PublicPropertyManager.shared.league.rawValue
    }
    
    // change league
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        guard let sideVC = menu.topViewController as? SideViewController else { return }
        if league != sideVC.selectedLeague {
            league = sideVC.selectedLeague
            PublicPropertyManager.shared.league = sideVC.selectedLeague
            navigationItem.leftBarButtonItem?.title = sideVC.selectedLeague.rawValue            
        }
    }
    
    // abstract method for fetching data
    internal func fetchData() { }
    
    func changeBackgroundColor() {
        let upperColor = league.colors[0]
        let bottomColor = league.colors[1]
        let colors = [upperColor.cgColor, bottomColor.cgColor]
        
        gradient.colors = colors
        navigationController?.navigationBar.standardAppearance.backgroundColor = upperColor
    }
    
    func navAppearenceConfig() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let scrollEdgeAppearence = UINavigationBarAppearance()
        scrollEdgeAppearence.configureWithTransparentBackground()
        scrollEdgeAppearence.titleTextAttributes = [.foregroundColor : UIColor.white]
        scrollEdgeAppearence.largeTitleTextAttributes = [.foregroundColor : UIColor.white]
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearence
        
        let standardAppearence = UINavigationBarAppearance()
        standardAppearence.configureWithOpaqueBackground()
        standardAppearence.backgroundColor = league.colors[0]
        standardAppearence.titleTextAttributes = [.foregroundColor : UIColor.white]
        navigationController?.navigationBar.standardAppearance = standardAppearence
    }
}
