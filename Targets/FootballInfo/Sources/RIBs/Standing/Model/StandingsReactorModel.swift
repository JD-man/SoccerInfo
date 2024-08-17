//
//  StandingsReactorModel.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/11.
//

import Foundation

struct StandingsReactorModel {
  enum Action {
    case fetchStandings
  }
  
  enum Mutation {
    case setStandingsSection
  }
  
  struct State {
    var leagueInfo: LeagueInfo = LeagueInfo(league: .premierLeague)
    let standingsSection: [Int] = []
  }
}
