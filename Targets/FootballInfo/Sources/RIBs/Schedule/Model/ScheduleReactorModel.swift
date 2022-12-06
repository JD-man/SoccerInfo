//
//  ScheduleReactorModel.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/01.
//

import Foundation

struct ScheduleReactorModel {
  typealias TotalScheduleDictionary = [String: [ScheduleSectionModel.Item]]
  enum Action {
    case fetchSchedule
    case prevSchedule
    case nextSchedule
    case showSideMenu
    case showMatchDetail(ScheduleSectionModel.Item)
    case showReserveAlert
  }
  
  enum Mutation {
    case setFirstDay(Date)
    case setLeagueInfo(LeagueInfo)
    case setTotalScheduleDictionary(TotalScheduleDictionary)
    case setWeeklyScheduleContent([ScheduleSectionModel])
    case setIsSideMenuShown(Bool)
    case setPresentReserveAlert(Void?)
  }
  
  struct State {
    var firstDay: Date
    var isSideMenuShown: Bool = false
    var leagueInfo: LeagueInfo = LeagueInfo(league: .premierLeague)
    var totalScheduleDictionary: TotalScheduleDictionary = [:]
    var weeklyScheduleContent: [ScheduleSectionModel] = []
    var presentReserveAlert: Void?
  }
}
