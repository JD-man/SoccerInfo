//
//  ScheduleInteractor.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs
import RxSwift

protocol ScheduleRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SchedulePresentable: Presentable {
  var listener: SchedulePresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ScheduleListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ScheduleInteractor: PresentableInteractor<SchedulePresentable>, ScheduleInteractable, SchedulePresentableListener {
  var viewAction: ActionSubject<ScheduleReactorModel.Action> { action }
  var viewState: Observable<ScheduleReactorModel.State> { state }
  
  weak var router: ScheduleRouting?
  weak var listener: ScheduleListener?
  private let useCase: ScheduleUseCaseProtocol
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  init(
    presenter: SchedulePresentable,
    useCase: ScheduleUseCaseProtocol
  ) {
    self.useCase = useCase
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
