//
//  MainRouter.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs

protocol MainInteractable: Interactable,
                           ScheduleListener,
                           TeamScheduleListener,
                           StandingsListener,
                           NewsListener,
                           SideMenuListener {
  var router: MainRouting? { get set }
  var listener: MainListener? { get set }
}

protocol MainViewControllable: ViewControllable {
  func setViewControllers(_ viewControllables: [ViewControllable])
  func presentSideMenu(_ viewControllable: ViewControllable)
  func dismissSideMenu(_ viewControllable: ViewControllable)
}

final class MainRouter: Router<MainInteractable>, MainRouting {
  
  private let viewController: MainViewControllable
  
  private let scheduleBuilder: ScheduleBuildable
  private var scheduleRouter: ScheduleRouting?
  
  private let teamScheduleBuilder: TeamScheduleBuildable
  private var teamScheduleRouter: TeamScheduleRouting?
  
  private let StandingsBuilder: StandingsBuildable
  private var StandingsRouter: StandingsRouting?
  
  private let newsBuilder: NewsBuildable
  private var newsRouter: NewsRouting?
  
  private let sideMenuBuilder: SideMenuBuildable
  private var sideMenuRouter: SideMenuRouting?
  
  init(
    interactor: MainInteractable,
    viewController: MainViewControllable,
    scheduleBuilder: ScheduleBuildable,
    teamScheduleBuilder: TeamScheduleBuildable,
    StandingsBuilder: StandingsBuildable,
    newsBuilder: NewsBuildable,
    sideMenuBuilder: SideMenuBuildable
  ) {
    self.viewController = viewController
    self.scheduleBuilder = scheduleBuilder
    self.teamScheduleBuilder = teamScheduleBuilder
    self.StandingsBuilder = StandingsBuilder
    self.newsBuilder = newsBuilder
    self.sideMenuBuilder = sideMenuBuilder
    super.init(interactor: interactor)
    interactor.router = self
  }
  
  func cleanupViews() {}
  
  func setTabViews() {
    guard scheduleRouter == nil,
          teamScheduleRouter == nil,
          StandingsRouter == nil,
          newsRouter == nil
    else {
      return
    }
    
    let scheduleRouter = scheduleBuilder.build(withListener: interactor)
    let teamScheduleRouter = teamScheduleBuilder.build(withListener: interactor)
    let StandingsRouter = StandingsBuilder.build(withListener: interactor)
    let newsRouter = newsBuilder.build(withListener: interactor)
    
    self.scheduleRouter = scheduleRouter
    self.teamScheduleRouter = teamScheduleRouter
    self.StandingsRouter = StandingsRouter
    self.newsRouter = newsRouter
    
    let routers = [scheduleRouter, teamScheduleRouter, StandingsRouter, newsRouter]
    routers.forEach { attachChild($0) }
    let viewControllables = routers.map { $0.viewControllable }
    
    viewController.setViewControllers(viewControllables)
  }
  
  func attachSideMenu(with currentLeagueInfo: LeagueInfo) {
    guard sideMenuRouter == nil else { return }
    let sideMenuRouter = sideMenuBuilder.build(withListener: interactor, currentLeagueInfo: currentLeagueInfo)
    self.sideMenuRouter = sideMenuRouter
    viewController.presentSideMenu(sideMenuRouter.viewControllable)
    
    attachChild(sideMenuRouter)
  }
  
  func detachSideMenu() {
    guard let sideMenuRouter = sideMenuRouter else { return }
    viewController.dismissSideMenu(sideMenuRouter.viewControllable)
    detachChild(sideMenuRouter)
    self.sideMenuRouter = nil
  }
}
