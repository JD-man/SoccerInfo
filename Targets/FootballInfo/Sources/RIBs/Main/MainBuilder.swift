//
//  MainBuilder.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs

protocol MainDependency: Dependency {
  var mainViewController: MainViewControllable { get }
}

final class MainComponent: Component<MainDependency>, MainInteractorDependency, SideMenuDependency {
  
  fileprivate var mainViewController: MainViewControllable {
    return dependency.mainViewController
  }
  
  var mutableLeagueInfoStream: MutableLeagueInfoStreamProtocol {
    return shared { MutableLeagueInfoStream() }
  }
}

// MARK: - Builder

protocol MainBuildable: Buildable {
  func build(withListener listener: MainListener) -> MainRouting
}

final class MainBuilder: Builder<MainDependency>, MainBuildable {
  
  override init(dependency: MainDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: MainListener) -> MainRouting {
    let component = MainComponent(dependency: dependency)
    let interactor = MainInteractor(dependency: component)
    interactor.listener = listener
    
    let scheduleBuilder = ScheduleBuilder(dependency: component)
    let teamScheduleBuilder = TeamScheduleBuilder(dependency: component)
    let StandingsBuilder = StandingsBuilder(dependency: component)
    let newsBuilder = NewsBuilder(dependency: component)
    let sideMenuBuilder = SideMenuBuilder(dependency: component)
    
    return MainRouter(
      interactor: interactor,
      viewController: component.mainViewController,
      scheduleBuilder: scheduleBuilder,
      teamScheduleBuilder: teamScheduleBuilder,
      StandingsBuilder: StandingsBuilder,
      newsBuilder: newsBuilder,
      sideMenuBuilder: sideMenuBuilder
    )
  }
}

// MARK: MainComponent Dependecy
extension MainComponent: ScheduleDependency,
                         TeamScheduleDependency,
                         StandingsDependency,
                         NewsDependency {
  
  var leagueInfoStream: LeagueInfoStreamProtocol {
    return mutableLeagueInfoStream
  }
}
