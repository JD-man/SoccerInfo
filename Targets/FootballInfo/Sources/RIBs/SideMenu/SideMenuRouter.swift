//
//  SideMenuRouter.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/03.
//

import RIBs

protocol SideMenuInteractable: Interactable {
    var router: SideMenuRouting? { get set }
    var listener: SideMenuListener? { get set }
}

protocol SideMenuViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SideMenuRouter: ViewableRouter<SideMenuInteractable, SideMenuViewControllable>, SideMenuRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SideMenuInteractable, viewController: SideMenuViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
