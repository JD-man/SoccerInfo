//
//  MatchDetailModel.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/27.
//

import Foundation

struct MatchDetailEntity {
    var fixtureID: Int
    var events: [EventsEntity]
    var homeStartLineup: [LineupEntity]
    var homeSubLineup: [LineupEntity]
    var homeFormation: String
    var awayStartLineup: [LineupEntity]
    var awaySubLineup: [LineupEntity]
    var awayFormation: String
}

extension MatchDetailEntity {
  struct EventsEntity {
      var time: Int
      var teamName: String
      var player: String
      var assist: String?
      var eventType: String
      var eventDetail: String
  }

  struct LineupEntity {
      var name: String
      var number: Int
      var position: String
      var grid: String?
  }
}
