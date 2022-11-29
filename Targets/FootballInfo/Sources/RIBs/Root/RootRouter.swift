//
//  RootRouter.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs

protocol RootInteractable: Interactable, MainListener {
  var router: RootRouting? { get set }
  var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
  
  private let mainBuilder: MainBuildable
  private var mainRouting: MainRouting?
  
  init(
    interactor: RootInteractable,
    viewController: RootViewControllable,
    mainBuilder: MainBuildable
  ) {
    self.mainBuilder = mainBuilder
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  
  func attachMain() {
    guard mainRouting == nil else { return }
    
    let mainRouting = mainBuilder.build(withListener: interactor)
    self.mainRouting = mainRouting
    attachChild(mainRouting)
  }
}
