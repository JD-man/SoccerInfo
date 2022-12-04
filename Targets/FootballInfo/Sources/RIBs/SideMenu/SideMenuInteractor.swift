//
//  SideMenuInteractor.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/03.
//

import RIBs
import RxSwift

protocol SideMenuRouting: ViewableRouting { }

protocol SideMenuPresentable: Presentable {
  var listener: SideMenuPresentableListener? { get set }
}

protocol SideMenuListener: AnyObject {
  func didLeagueSelect(of leagueInfo: LeagueInfo)
  func detachSideMenu()
}

final class SideMenuInteractor: PresentableInteractor<SideMenuPresentable>, SideMenuInteractable, SideMenuPresentableListener {
  
  weak var router: SideMenuRouting?
  weak var listener: SideMenuListener?
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: SideMenuPresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
  
  func didLeagueSelectedInSideMenu(of leagueInfo: LeagueInfo) {
    listener?.didLeagueSelect(of: leagueInfo)
    dismissSideMenu()
  }
  
  func dismissSideMenu() {
    listener?.detachSideMenu()
  }
}
