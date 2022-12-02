//
//  LeagueInfoStreamProtocol.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/02.
//

import Foundation
import RxSwift
import RxRelay

protocol LeagueInfoStreamProtocol: AnyObject {
  var leagueInfo: Observable<LeagueInfo> { get }
}

protocol MutableLeagueInfoStreamProtocol: LeagueInfoStreamProtocol {
  func changeLeagueInfo(to league: LeagueInfo)
}


