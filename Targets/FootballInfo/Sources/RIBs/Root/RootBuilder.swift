//
//  RootBuilder.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs

protocol RootDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class RootComponent: Component<RootDependency>, MainDependency {
  var mainViewController: MainViewControllable {
    return rootViewController
  }
  
  private let rootViewController: RootViewController
  
  init(
    dependency: RootDependency,
    rootViewController: RootViewController
  ) {
    self.rootViewController = rootViewController
    super.init(dependency: dependency)
  }
}

// MARK: - Builder

protocol RootBuildable: Buildable {
  func build() -> LaunchRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {
  
  override init(dependency: RootDependency) {
    super.init(dependency: dependency)
  }
  
  func build() -> LaunchRouting {
    let viewController = RootViewController()
    
    let component = RootComponent(
      dependency: dependency,
      rootViewController: viewController
    )
    
    let interactor = RootInteractor(presenter: viewController)
    let mainBuilder = MainBuilder(dependency: component)
    
    return RootRouter(
      interactor: interactor,
      viewController: viewController,
      mainBuilder: mainBuilder
    )
  }
}
