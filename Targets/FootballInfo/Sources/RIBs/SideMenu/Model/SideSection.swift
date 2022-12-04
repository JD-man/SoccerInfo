//
//  SideSection.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/03.
//

import Foundation

enum SideSection: CaseIterable {
  case league
  // case cup ... update later
  
  var title: String {
    switch self {
    case .league:
      return "Leagues"
    @unknown default:
      print("SideSection title unknown default")
    }
  }
  
  var contents: [String] {
    switch self {
    case .league:
      return LeagueInfo.League.allCases.map { $0.rawValue }
    @unknown default:
      print("SideSection contents unknown default")
    }
  }
}
