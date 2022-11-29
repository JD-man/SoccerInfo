//
//  RankBuilder.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs

protocol RankDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class RankComponent: Component<RankDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RankBuildable: Buildable {
  func build(withListener listener: RankListener) -> RankRouting
}

final class RankBuilder: Builder<RankDependency>, RankBuildable {
  
  override init(dependency: RankDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: RankListener) -> RankRouting {
    let component = RankComponent(dependency: dependency)
    let viewController = RankViewController()
    let interactor = RankInteractor(presenter: viewController)
    interactor.listener = listener
    return RankRouter(interactor: interactor, viewController: viewController)
  }
}
