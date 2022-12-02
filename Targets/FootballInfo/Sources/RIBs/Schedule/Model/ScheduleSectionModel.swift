//
//  ScheduleSectionModel.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/02.
//

import Foundation
import RxDataSources

struct ScheduleSectionModel: AnimatableSectionModelType {
  typealias Identity = String
  
  var identity: String { return dateHeader }
  
  var dateHeader: String
  var items: [Item]
}

extension ScheduleSectionModel {
  init(original: ScheduleSectionModel, items: [Item]) {
    self = original
    self.items = items
  }
}

extension ScheduleSectionModel {
  struct Item: IdentifiableType, Equatable {
    typealias Identity = Int
    var identity: Int { fixtureID }
    
    let leagueInfo: LeagueInfo
    let homeID: Int
    let homeName: String
    let homeLogo: String
    var homeGoal: Int?
    
    let awayID: Int
    let awayName: String
    let awayLogo: String
    var awayGoal: Int?
    
    let matchHour: String
    let fixtureID: Int
    
    static func emptyContent(id: Int, leagueInfo: LeagueInfo) -> Item {
      return .init(leagueInfo: leagueInfo,
                   homeID: 0,
                   homeName: "empty",
                   homeLogo: "",
                   awayID: 0,
                   awayName: "",
                   awayLogo: "",
                   matchHour: "",
                   fixtureID: id)
    }
  }
}
