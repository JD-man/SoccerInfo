//
//  Dependencies.swift
//  Config
//
//  Created by 조동현 on 2022/11/28.
//

import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
      .remote(url: "https://github.com/uber/RIBs.git",
              requirement: .upToNextMajor(from: "0.13.0")),
      .remote(url: "https://github.com/ReactiveX/RxSwift.git",
              requirement: .upToNextMajor(from: "6.5.0")),
      .remote(url: "https://github.com/Alamofire/Alamofire.git",
              requirement: .upToNextMajor(from: "5.6.0")),
      .remote(url: "https://github.com/SnapKit/SnapKit.git",
              requirement: .upToNextMajor(from: "5.6.0")),
      .remote(url: "https://github.com/onevcat/Kingfisher.git",
              requirement: .upToNextMajor(from: "7.4.0")),
//      .remote(url: "https://github.com/realm/realm-swift.git",
//              requirement: .branch("master")),
      .remote(url: "https://github.com/jonkykong/SideMenu.git",
              requirement: .upToNextMajor(from: "6.5.0")),
      .remote(url: "https://github.com/danielgindi/Charts.git",
              requirement: .upToNextMajor(from: "4.1.0")),
      .remote(url: "https://github.com/firebase/firebase-ios-sdk.git",
              requirement: .upToNextMajor(from: "8.0.0"))
    ],
    platforms: [.iOS]
)
