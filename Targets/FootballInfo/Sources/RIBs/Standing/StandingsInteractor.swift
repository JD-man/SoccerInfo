//
//  StandingsInteractor.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs
import RxSwift
import ReactorKit

protocol StandingsRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol StandingsPresentable: Presentable {
  var listener: StandingsPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol StandingsListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class StandingsInteractor: PresentableInteractor<StandingsPresentable>, StandingsInteractable, StandingsPresentableListener {
  
  weak var router: StandingsRouting?
  weak var listener: StandingsListener?
  
  var viewAction: ActionSubject<StandingsReactorModel.Action> { action }
  var viewState: Observable<StandingsReactorModel.State> { state }
  var initialState = State()
  
  private let standingsUseCase: StandingsUseCaseProtocol
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  init(
    presenter: StandingsPresentable,
    standingsUseCase: StandingsUseCaseProtocol
  ) {
    self.standingsUseCase = standingsUseCase
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
