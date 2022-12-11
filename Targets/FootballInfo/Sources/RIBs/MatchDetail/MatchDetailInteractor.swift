//
//  MatchDetailInteractor.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/04.
//

import RIBs
import RxSwift
import RxCocoa
import ReactorKit

protocol MatchDetailRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MatchDetailPresentable: Presentable {
  var listener: MatchDetailPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MatchDetailListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MatchDetailInteractor: PresentableInteractor<MatchDetailPresentable>, MatchDetailInteractable, MatchDetailPresentableListener {
  
  typealias Action = MatchDetailReactorModel.Action
  typealias Mutation = MatchDetailReactorModel.Mutation
  typealias State = MatchDetailReactorModel.State
  
  var viewAction: ReactorKit.ActionSubject<MatchDetailReactorModel.Action> { action }
  var viewState: RxSwift.Observable<MatchDetailReactorModel.State> { state }
  
  weak var router: MatchDetailRouting?
  weak var listener: MatchDetailListener?
  
  var initialState: State
  private let useCase: MatchDetailUseCaseProtocol
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  init(
    presenter: MatchDetailPresentable,
    fixtureId: Int,
    leagueInfo: LeagueInfo,
    headerModel: MatchDetailHeaderModel,
    useCase: MatchDetailUseCaseProtocol
  ) {
    self.useCase = useCase
    self.initialState = State(fixtureId: fixtureId, leagueInfo: leagueInfo, headerModel: headerModel)
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
}

extension MatchDetailInteractor: Reactor {
  func mutate(action: MatchDetailReactorModel.Action) -> Observable<MatchDetailReactorModel.Mutation> {
    switch action {
    case .fetchMatchDetail:
      let fixtureId = currentState.fixtureId
      let season = currentState.leagueInfo.season
      let league = currentState.leagueInfo.league
      return useCase.executeRealmMatchDetail(season: season, league: league.rawValue, fixtureId: fixtureId)
        .withUnretained(self)
        .flatMap { interactor, matchDetailEntity -> Observable<MatchDetailReactorModel.Mutation> in
          let eventSection = interactor.configureEventSection(of: matchDetailEntity)
          let formationSection = interactor.configureFormationSection(of: matchDetailEntity)
          let startingLineupSection = interactor.configureStartingLineupSectionItem(of: matchDetailEntity)
          let benchLineupSection = interactor.configureBenchLineupSectionItem(of: matchDetailEntity)
          return .just(.setMatchDetailSection([eventSection, formationSection, startingLineupSection, benchLineupSection]))
        }
    }
  }
  
  func reduce(state: MatchDetailReactorModel.State, mutation: MatchDetailReactorModel.Mutation) -> MatchDetailReactorModel.State {
    var newState = state
    switch mutation {
    case .setMatchDetailSection(let section):
      newState.matchDetailSection = section
    }
    return newState
  }
  
}

// MARK: - Match Detail TableView Section
extension MatchDetailInteractor {
  private func configureEventSection(of matchDetailEntity: MatchDetailEntity) -> MatchDetailSectionModel {
    let homeTeamName = currentState.headerModel.homeTeamName
    let sectionItem = matchDetailEntity.events.map {
      let isHomeCell = $0.teamName == homeTeamName
      return MatchDetailSectionModel.Item.eventCell($0, isHomeCell)
    }
    return MatchDetailSectionModel(section: .event, items: sectionItem)
  }
  
  private func configureFormationSection(of matchDetailEntity: MatchDetailEntity) -> MatchDetailSectionModel {
    let homeLineup = matchDetailEntity.homeStartLineup
    let awayLineup = matchDetailEntity.awayStartLineup
    let sectionItem = [MatchDetailSectionModel.Item.formationCell(homeLineup, awayLineup)]
    return MatchDetailSectionModel(section: .formation, items: sectionItem)
  }
  
  private func configureStartingLineupSectionItem(of matchDetailEntity: MatchDetailEntity) -> MatchDetailSectionModel {
    let homeLineup = matchDetailEntity.homeStartLineup
    let awayLineup = matchDetailEntity.awayStartLineup
    let leagueInfo = currentState.leagueInfo
    
    let sectionItem = zip(homeLineup, awayLineup).map { homePlayer, awayPlayer in
      return MatchDetailSectionModel.Item.startingLineupCell(homePlayer, awayPlayer, leagueInfo)
    }
    return MatchDetailSectionModel(section: .startingLineup, items: sectionItem)
  }
  
  private func configureBenchLineupSectionItem(of matchDetailEntity: MatchDetailEntity) -> MatchDetailSectionModel {
    let homeLineup = matchDetailEntity.homeSubLineup
    let awayLineup = matchDetailEntity.awaySubLineup
    let leagueInfo = currentState.leagueInfo
    
    let sectionItem = zip(homeLineup, awayLineup).map { homePlayer, awayPlayer in
      return MatchDetailSectionModel.Item.startingLineupCell(homePlayer, awayPlayer, leagueInfo)
    }
    return MatchDetailSectionModel(section: .benchLineup, items: sectionItem)
  }
}
