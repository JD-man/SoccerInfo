//
//  MainInteractor.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs
import RxSwift

protocol MainRouting: Routing {
  func cleanupViews()
  func setTabViews()
}

protocol MainListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MainInteractor: Interactor, MainInteractable {
  
  weak var router: MainRouting?
  weak var listener: MainListener?
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init() {}
  
  override func didBecomeActive() {
    super.didBecomeActive()
    setTabs()
  }
  
  override func willResignActive() {
    super.willResignActive()
    router?.cleanupViews()
  }
  
  private func setTabs() {
    router?.setTabViews()
  }
}
