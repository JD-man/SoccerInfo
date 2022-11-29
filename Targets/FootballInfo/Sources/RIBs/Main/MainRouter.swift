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
                           RankListener,
                           NewsListener {
  var router: MainRouting? { get set }
  var listener: MainListener? { get set }
}

protocol MainViewControllable: ViewControllable {
  func setViewControllers(_ viewControllables: [ViewControllable])
}

final class MainRouter: Router<MainInteractable>, MainRouting {
  private let viewController: MainViewControllable
  
  private let scheduleBuilder: ScheduleBuildable
  private var scheduleRouter: ScheduleRouting?
  
  private let teamScheduleBuilder: TeamScheduleBuildable
  private var teamScheduleRouter: TeamScheduleRouting?
  
  private let rankBuilder: RankBuildable
  private var rankRouter: RankRouting?
  
  private let newsBuilder: NewsBuildable
  private var newsRouter: NewsRouting?
  
  init(
    interactor: MainInteractable,
    viewController: MainViewControllable,
    scheduleBuilder: ScheduleBuildable,
    teamScheduleBuilder: TeamScheduleBuildable,
    rankBuilder: RankBuildable,
    newsBuilder: NewsBuildable
  ) {
    self.viewController = viewController
    self.scheduleBuilder = scheduleBuilder
    self.teamScheduleBuilder = teamScheduleBuilder
    self.rankBuilder = rankBuilder
    self.newsBuilder = newsBuilder
    super.init(interactor: interactor)
    interactor.router = self
  }
  
  func cleanupViews() {}
  
  func setTabViews() {
    guard scheduleRouter == nil,
          teamScheduleRouter == nil,
          rankRouter == nil,
          newsRouter == nil
    else {
      return
    }
    
    let scheduleRouter = scheduleBuilder.build(withListener: interactor)
    let teamScheduleRouter = teamScheduleBuilder.build(withListener: interactor)
    let rankRouter = rankBuilder.build(withListener: interactor)
    let newsRouter = newsBuilder.build(withListener: interactor)
    
    self.scheduleRouter = scheduleRouter
    self.teamScheduleRouter = teamScheduleRouter
    self.rankRouter = rankRouter
    self.newsRouter = newsRouter
    
    let routers = [scheduleRouter, teamScheduleRouter, rankRouter, newsRouter]
    routers.forEach { attachChild($0) }
    let viewControllables = routers.map { $0.viewControllable }
    
    viewController.setViewControllers(viewControllables)
  }
}
