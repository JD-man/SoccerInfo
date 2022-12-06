//
//  MatchDetailInteractor.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/04.
//

import RIBs
import RxSwift

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
  
  weak var router: MatchDetailRouting?
  weak var listener: MatchDetailListener?
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: MatchDetailPresentable) {
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
