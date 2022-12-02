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
  }
  
  enum Mutation {
    case setFirstDay(Date)
    case setTotalScheduleDictionary(TotalScheduleDictionary)
    case setWeeklyScheduleContent([ScheduleSectionModel])
  }
  
  struct State {
    var firstDay: Date
    var totalScheduleDictionary: TotalScheduleDictionary = [:]
    var weeklyScheduleContent: [ScheduleSectionModel] = []
  }
}
