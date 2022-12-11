//
//  StandingsBuilder.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs

protocol StandingsDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class StandingsComponent: Component<StandingsDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol StandingsBuildable: Buildable {
  func build(withListener listener: StandingsListener) -> StandingsRouting
}

final class StandingsBuilder: Builder<StandingsDependency>, StandingsBuildable {
  
  override init(dependency: StandingsDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: StandingsListener) -> StandingsRouting {
    let component = StandingsComponent(dependency: dependency)
    let viewController = StandingsViewController()
    let interactor = StandingsInteractor(presenter: viewController)
    interactor.listener = listener
    return StandingsRouter(interactor: interactor, viewController: viewController)
  }
}
