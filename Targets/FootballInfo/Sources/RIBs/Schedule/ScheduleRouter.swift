//
//  ScheduleRouter.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs

protocol ScheduleInteractable: Interactable, MatchDetailListener {
  var router: ScheduleRouting? { get set }
  var listener: ScheduleListener? { get set }
}

protocol ScheduleViewControllable: ViewControllable {
  func pushMatchDetail(_ viewControllable: ViewControllable)
  func popMatchDetail()
}

final class ScheduleRouter: ViewableRouter<ScheduleInteractable, ScheduleViewControllable>, ScheduleRouting {
  
  private let matchDetailBuilder: MatchDetailBuildable
  private var matchDetailRouter: MatchDetailRouting?
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(
    interactor: ScheduleInteractable,
    viewController: ScheduleViewControllable,
    matchDetailBuilder: MatchDetailBuildable)
  {
    self.matchDetailBuilder = matchDetailBuilder
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}

// MARK: - MatchDetail Routing
extension ScheduleRouter {
  func attachMatchDetail(fixtureId: Int, leagueInfo: LeagueInfo, headerModel: MatchDetailHeaderModel) {
    guard matchDetailRouter == nil else { return }
    
    let matchDetailRouter = matchDetailBuilder.build(
      withListener: interactor,
      fixtureId: fixtureId,
      leagueInfo: leagueInfo,
      headerModel: headerModel
    )
    
    self.matchDetailRouter = matchDetailRouter
    viewController.pushMatchDetail(matchDetailRouter.viewControllable)
    attachChild(matchDetailRouter)
  }
  
  func detachMatchDetail() {
    print("detach match Detail")
  }
  
  func presentNotiAlert() {
    print("present noti alert")
  }
}
