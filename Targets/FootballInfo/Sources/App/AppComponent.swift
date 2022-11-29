//
//  AppComponent.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs

final class AppComponent: Component<EmptyComponent>, RootDependency {
  init() {
    super.init(dependency: EmptyComponent())
  }
}
