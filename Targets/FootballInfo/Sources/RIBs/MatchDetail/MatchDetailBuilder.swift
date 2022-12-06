//
//  MatchDetailBuilder.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/04.
//

import RIBs

protocol MatchDetailDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class MatchDetailComponent: Component<MatchDetailDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MatchDetailBuildable: Buildable {
  func build(withListener listener: MatchDetailListener) -> MatchDetailRouting
}

final class MatchDetailBuilder: Builder<MatchDetailDependency>, MatchDetailBuildable {
  
  override init(dependency: MatchDetailDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: MatchDetailListener) -> MatchDetailRouting {
    let component = MatchDetailComponent(dependency: dependency)
    let viewController = MatchDetailViewController()
    let interactor = MatchDetailInteractor(presenter: viewController)
    interactor.listener = listener
    return MatchDetailRouter(interactor: interactor, viewController: viewController)
  }
}
