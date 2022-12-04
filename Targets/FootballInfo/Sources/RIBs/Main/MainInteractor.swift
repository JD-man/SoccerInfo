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
  func attachSideMenu(with currentLeagueInfo: LeagueInfo)
  func detachSideMenu()
}

protocol MainListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol MainInteractorDependency {
  var mutableLeagueInfoStream: MutableLeagueInfoStreamProtocol { get }
}

final class MainInteractor: Interactor, MainInteractable {
  
  weak var router: MainRouting?
  weak var listener: MainListener?
  private let dependency: MainInteractorDependency
  
  init(dependency: MainInteractorDependency) {
    self.dependency = dependency
  }
  
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
  
  // MARK: - League Info Stream
  func didLeagueSelect(of currentLeagueInfo: LeagueInfo) {
    dependency.mutableLeagueInfoStream.changeLeagueInfo(to: currentLeagueInfo)
    detachSideMenu()
  }
}

// MARK: - Side Menu Routing
extension MainInteractor {
  func attachSideMenu(with leagueInfo: LeagueInfo) {
    router?.attachSideMenu(with: leagueInfo)
  }
  
  func detachSideMenu() {
    router?.detachSideMenu()
  }
}
