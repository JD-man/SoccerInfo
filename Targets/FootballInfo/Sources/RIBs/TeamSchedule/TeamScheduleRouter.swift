//
//  TeamScheduleRouter.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs

protocol TeamScheduleInteractable: Interactable {
  var router: TeamScheduleRouting? { get set }
  var listener: TeamScheduleListener? { get set }
}

protocol TeamScheduleViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TeamScheduleRouter: ViewableRouter<TeamScheduleInteractable, TeamScheduleViewControllable>, TeamScheduleRouting {
  
  // TODO: Constructor inject child builder protocols to allow building children.
  override init(interactor: TeamScheduleInteractable, viewController: TeamScheduleViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
