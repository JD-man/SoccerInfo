//
//  StandingsRouter.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs

protocol StandingsInteractable: Interactable {
  var router: StandingsRouting? { get set }
  var listener: StandingsListener? { get set }
}

protocol StandingsViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class StandingsRouter: ViewableRouter<StandingsInteractable, StandingsViewControllable>, StandingsRouting {
  
  // TODO: Constructor inject child builder protocols to allow building children.
  override init(interactor: StandingsInteractable, viewController: StandingsViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
