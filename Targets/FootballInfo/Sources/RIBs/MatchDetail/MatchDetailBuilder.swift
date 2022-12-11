//
//  MatchDetailBuilder.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/04.
//

import RIBs

protocol MatchDetailDependency: Dependency { }

final class MatchDetailComponent: Component<MatchDetailDependency> {
  fileprivate let fixtureId: Int
  fileprivate let leagueInfo: LeagueInfo
  
  init(dependency: MatchDetailDependency, fixtureId: Int, leagueInfo: LeagueInfo) {
    self.fixtureId = fixtureId
    self.leagueInfo = leagueInfo
    super.init(dependency: dependency)
  }
}

// MARK: - Builder

protocol MatchDetailBuildable: Buildable {
  func build(
    withListener listener: MatchDetailListener,
    fixtureId: Int,
    leagueInfo: LeagueInfo,
    headerModel: MatchDetailHeaderModel) -> MatchDetailRouting
}

final class MatchDetailBuilder: Builder<MatchDetailDependency>, MatchDetailBuildable {
  
  override init(dependency: MatchDetailDependency) {
    super.init(dependency: dependency)
  }
  
  func build(
    withListener listener: MatchDetailListener,
    fixtureId: Int,
    leagueInfo: LeagueInfo,
    headerModel: MatchDetailHeaderModel) -> MatchDetailRouting
  {
    let component = MatchDetailComponent(
      dependency: dependency,
      fixtureId: fixtureId,
      leagueInfo: leagueInfo
    )
    let viewController = MatchDetailViewController()
    let footballRepository = FootballRepository()
    let footballRealmRepository = FootballRealmRepository()
    let useCase = MatchDetailUseCase(footballRepository: footballRepository, footballRealmRepository: footballRealmRepository)
    let interactor = MatchDetailInteractor(
      presenter: viewController,
      fixtureId: component.fixtureId,
      leagueInfo: component.leagueInfo,
      headerModel: headerModel,
      useCase: useCase
    )
    interactor.listener = listener
    return MatchDetailRouter(interactor: interactor, viewController: viewController)
  }
}
