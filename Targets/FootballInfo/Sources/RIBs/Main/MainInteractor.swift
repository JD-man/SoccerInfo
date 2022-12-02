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
  
  // MARK: - LeagueInfo Stream
  func changeLeagueInfo(of leagueInfo: LeagueInfo) {
    dependency.mutableLeagueInfoStream.changeLeagueInfo(to: leagueInfo)
  }
}
