//
//  NewsRouter.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs

protocol NewsInteractable: Interactable {
  var router: NewsRouting? { get set }
  var listener: NewsListener? { get set }
}

protocol NewsViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class NewsRouter: ViewableRouter<NewsInteractable, NewsViewControllable>, NewsRouting {
  
  // TODO: Constructor inject child builder protocols to allow building children.
  override init(interactor: NewsInteractable, viewController: NewsViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
