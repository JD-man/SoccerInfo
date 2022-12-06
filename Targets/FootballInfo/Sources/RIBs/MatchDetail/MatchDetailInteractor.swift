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
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  init(
    presenter: MatchDetailPresentable,
    fixtureId: Int,
    leagueInfo: LeagueInfo,
    headerModel: MatchDetailHeaderModel) {
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
      
    }
  }
  
  func reduce(state: MatchDetailReactorModel.State, mutation: MatchDetailReactorModel.Mutation) -> MatchDetailReactorModel.State {
    var newState = state
    switch mutation {
      
    }
    return newState
  }
  
}
