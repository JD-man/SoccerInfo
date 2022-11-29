//
//  TeamScheduleBuilder.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs

protocol TeamScheduleDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class TeamScheduleComponent: Component<TeamScheduleDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TeamScheduleBuildable: Buildable {
  func build(withListener listener: TeamScheduleListener) -> TeamScheduleRouting
}

final class TeamScheduleBuilder: Builder<TeamScheduleDependency>, TeamScheduleBuildable {
  
  override init(dependency: TeamScheduleDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: TeamScheduleListener) -> TeamScheduleRouting {
    let component = TeamScheduleComponent(dependency: dependency)
    let viewController = TeamScheduleViewController()
    let interactor = TeamScheduleInteractor(presenter: viewController)
    interactor.listener = listener
    return TeamScheduleRouter(interactor: interactor, viewController: viewController)
  }
}
