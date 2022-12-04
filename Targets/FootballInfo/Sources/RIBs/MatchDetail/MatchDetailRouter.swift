//
//  MatchDetailRouter.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/04.
//

import RIBs

protocol MatchDetailInteractable: Interactable {
    var router: MatchDetailRouting? { get set }
    var listener: MatchDetailListener? { get set }
}

protocol MatchDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MatchDetailRouter: ViewableRouter<MatchDetailInteractable, MatchDetailViewControllable>, MatchDetailRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MatchDetailInteractable, viewController: MatchDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
