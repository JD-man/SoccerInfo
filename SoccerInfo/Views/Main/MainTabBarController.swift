//
//  MainTabBarController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/18.
//

import UIKit
import RealmSwift

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
    }
    
    private func viewConfig() {
        let viewControllers = TabbarItem.allCases.map { item -> UIViewController in
            let vc = item.viewController
            vc.tabBarItem.image = UIImage(systemName: item.tabbarImageName)
            return vc
        }
        setViewControllers(viewControllers, animated: false)
    }
}

extension MainTabBarController {
    
    enum TabbarItem: CaseIterable {
        case fixtures
        case teamSchedules
        case standings
        case news
        
        var viewController: UIViewController {
            switch self {
            case .fixtures:
                return FixturesViewController()
            case .teamSchedules:
                return TeamSchedulesViewController()
            case .standings:
                return StandingsViewController()
            case .news:
                return NewsViewController()
            }
        }
        
        var tabbarImageName: String {
            switch self {
            case .fixtures:
                return "calendar"
            case .teamSchedules:
                return "puzzlepiece"
            case .standings:
                return "list.number"
            case .news:
                return "newspaper"
            }
        }
    }
}
