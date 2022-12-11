//
//  ScheduleBuilder.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs
import RxSwift

protocol ScheduleDependency: Dependency {
  var leagueInfoStream: LeagueInfoStreamProtocol { get }
}

final class ScheduleComponent: Component<ScheduleDependency>, ScheduleInteractorDependency, MatchDetailDependency {
  var leagueInfoStream: LeagueInfoStreamProtocol { dependency.leagueInfoStream }
}

// MARK: - Builder

protocol ScheduleBuildable: Buildable {
  func build(withListener listener: ScheduleListener) -> ScheduleRouting
}

final class ScheduleBuilder: Builder<ScheduleDependency>, ScheduleBuildable {
  
  override init(dependency: ScheduleDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: ScheduleListener) -> ScheduleRouting {
    let component = ScheduleComponent(dependency: dependency)
    let viewController = ScheduleViewController()
    
    // TODO: DI
    let footballRepository = FootballRepository()
    let footballRealmRepository = FootballRealmRepository()
    
    let useCase = ScheduleUseCase(
      footballRepository: footballRepository,
      footballRealmRepository: footballRealmRepository
    )
    
    let interactor = ScheduleInteractor(
      presenter: viewController,
      useCase: useCase,
      dependency: component
    )
    interactor.listener = listener
    
    let matchDetailBuilder = MatchDetailBuilder(dependency: component)
    return ScheduleRouter(
      interactor: interactor,
      viewController: viewController,
      matchDetailBuilder: matchDetailBuilder
    )
  }
}
