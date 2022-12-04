//
//  SideMenuBuilder.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/03.
//

import RIBs
import SideMenu

protocol SideMenuDependency: Dependency { }

final class SideMenuComponent: Component<SideMenuDependency> {
  fileprivate var currentLeagueInfo: LeagueInfo
  
  init(dependency: SideMenuDependency, currentLeagueInfo: LeagueInfo) {
    self.currentLeagueInfo = currentLeagueInfo
    super.init(dependency: dependency)
  }
}

// MARK: - Builder

protocol SideMenuBuildable: Buildable {
  func build(withListener listener: SideMenuListener, currentLeagueInfo: LeagueInfo) -> SideMenuRouting
}

final class SideMenuBuilder: Builder<SideMenuDependency>, SideMenuBuildable {
  
  override init(dependency: SideMenuDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: SideMenuListener, currentLeagueInfo: LeagueInfo) -> SideMenuRouting {
    let component = SideMenuComponent(dependency: dependency, currentLeagueInfo: currentLeagueInfo)
    
    let rootViewController = SideMenuRootViewController(currentLeagueInfo: component.currentLeagueInfo)
    let viewController = SideMenuViewController(rootViewController: rootViewController)
    rootViewController.delegate = viewController
    
    let interactor = SideMenuInteractor(presenter: viewController)
    interactor.listener = listener
    return SideMenuRouter(interactor: interactor, viewController: viewController)
  }
}
