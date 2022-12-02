//
//  MutableLeagueInfoStream.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/02.
//

import Foundation
import RxSwift
import RxRelay

final class MutableLeagueInfoStream: MutableLeagueInfoStreamProtocol {
  private let leagueInfoRelay = PublishRelay<LeagueInfo>()
  
  var leagueInfo: Observable<LeagueInfo> { leagueInfoRelay.asObservable() }
  
  func changeLeagueInfo(to leagueInfo: LeagueInfo) {
    leagueInfoRelay.accept(leagueInfo)
  }
}
