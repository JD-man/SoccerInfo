//
//  FixtureRequestParameters.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import Foundation

// ScheduleUseCase 안으로 집어넣기??
struct FixturesRequestQuery: Encodable {
  var season: String
  var league: String
}
