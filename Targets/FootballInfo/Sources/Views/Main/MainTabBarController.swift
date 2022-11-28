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
        let viewControllers = TabbarItem.allCases.map { item -> UINavigationController in
            let vc = item.viewController
            vc.navigationItem.title = item.navigtaionItemTitle
            let nav = UINavigationController(rootViewController: vc)
            nav.tabBarItem.image = UIImage(systemName: item.tabbarImageName)
            return nav
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
        
        var navigtaionItemTitle: String {
            switch self {
            case .fixtures:
                return "경기일정"
            case .teamSchedules:
                return "팀별일정"
            case .standings:
                return "순위"
            case .news:
                return "뉴스"
            }
        }
    }
}
