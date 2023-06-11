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
      .remote(url: "https://github.com/RxSwiftCommunity/RxDataSources.git",
              requirement: .upToNextMajor(from: "5.0.0")),
      .remote(url: "https://github.com/RxSwiftCommunity/RxGesture.git",
              requirement: .upToNextMajor(from: "4.0.4")),
      .remote(url: "https://github.com/ReactorKit/ReactorKit.git",
              requirement: .upToNextMajor(from: "3.2.0")),
      .remote(url: "https://github.com/Moya/Moya.git",
              requirement: .upToNextMajor(from: "15.0.3")),
      .remote(url: "https://github.com/SnapKit/SnapKit.git",
              requirement: .upToNextMajor(from: "5.6.0")),
      .remote(url: "https://github.com/onevcat/Kingfisher.git",
              requirement: .upToNextMajor(from: "7.6.2")),
      .remote(url: "https://github.com/jonkykong/SideMenu.git",
              requirement: .upToNextMajor(from: "6.5.0")),
      .remote(url: "https://github.com/danielgindi/Charts.git",
              requirement: .upToNextMajor(from: "4.1.0")),
      .remote(url: "https://github.com/firebase/firebase-ios-sdk.git",
              requirement: .upToNextMajor(from: "10.0.0"))
    ],
    platforms: [.iOS]
)
