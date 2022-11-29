//
//  RankRouter.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs

protocol RankInteractable: Interactable {
  var router: RankRouting? { get set }
  var listener: RankListener? { get set }
}

protocol RankViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RankRouter: ViewableRouter<RankInteractable, RankViewControllable>, RankRouting {
  
  // TODO: Constructor inject child builder protocols to allow building children.
  override init(interactor: RankInteractable, viewController: RankViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
