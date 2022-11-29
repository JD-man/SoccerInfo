//
//  MainBuilder.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs

protocol MainDependency: Dependency {
  // TODO: Make sure to convert the variable into lower-camelcase.
  var mainViewController: MainViewControllable { get }
  // TODO: Declare the set of dependencies required by this RIB, but won't be
  // created by this RIB.
}

final class MainComponent: Component<MainDependency> {
  
  // TODO: Make sure to convert the variable into lower-camelcase.
  fileprivate var mainViewController: MainViewControllable {
    return dependency.mainViewController
  }
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
    let interactor = MainInteractor()
    interactor.listener = listener
    
    let scheduleBuilder = ScheduleBuilder(dependency: component)
    let teamScheduleBuilder = TeamScheduleBuilder(dependency: component)
    let rankBuilder = RankBuilder(dependency: component)
    let newsBuilder = NewsBuilder(dependency: component)
    
    return MainRouter(
      interactor: interactor,
      viewController: component.mainViewController,
      scheduleBuilder: scheduleBuilder,
      teamScheduleBuilder: teamScheduleBuilder,
      rankBuilder: rankBuilder,
      newsBuilder: newsBuilder
    )
  }
}

// MARK: MainComponent Dependecy
extension MainComponent: ScheduleDependency,
                         TeamScheduleDependency,
                         RankDependency,
                         NewsDependency {
  
}
