//
//  ScheduleError.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import Foundation

enum ScheduleError: Error {
  case emptyResult
  case realmErrorCastingFail
  case realmDefaultError
}
