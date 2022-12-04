//
//  RootViewController.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class RootViewController: UITabBarController, RootPresentable, RootViewControllable, MainViewControllable {
  
  weak var listener: RootPresentableListener?
  
  func setViewControllers(_ viewControllables: [ViewControllable]) {
    let viewControllers = makeViewControllers(of: viewControllables)
    
    setViewControllers(viewControllers, animated: false)
  }
  
  private func makeViewControllers(of viewControllables: [ViewControllable]) -> [UIViewController] {
    let viewControllers = viewControllables.map { $0.uiviewController }
    let TabbarItems = TabbarItem.allCases
    
    return zip(viewControllers, TabbarItems).map { vc, item in
      let nav = UINavigationController(rootViewController: vc)
      vc.tabbarViewControllerConfig(
        title: item.navigtaionItemTitle,
        icon: item.tabbarImageName)
      return nav
    }
  }
  
  func presentSideMenu(_ viewControllable: RIBs.ViewControllable) {
    present(viewControllable.uiviewController, animated: true)
  }
  
  func dismissSideMenu(_ viewControllable: ViewControllable) {
    viewControllable.uiviewController.dismiss(animated: true)
  }
}

extension RootViewController {
  private enum TabbarItem: CaseIterable {
    case fixtures
    case teamSchedules
    case standings
    case news
    
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
