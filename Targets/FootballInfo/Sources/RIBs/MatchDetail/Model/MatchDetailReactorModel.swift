//
//  MatchDetailReactorModel.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/06.
//

import Foundation

struct MatchDetailReactorModel {
  enum Action {
    // case fetchMatchDetail
  }
  
  enum Mutation {
    
  }
  
  struct State {
    let fixtureId: Int
    let leagueInfo: LeagueInfo
    let headerModel: MatchDetailHeaderModel
    //    let matchDetailSection: [MatchDetailSectionModel] = []
  }
}
