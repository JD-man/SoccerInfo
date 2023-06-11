//
//  FootballRealmRepositoryProtocol.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/10.
//

import Foundation
import RealmSwift
import RxSwift

protocol FootballRealmRepositoryProtocol: AnyObject {
  func fixture(season: Int, league: String) -> Observable<FixturesTable>
  func updateFixture(fixturesData: [FixturesRealmData], season: Int, league: String)
  
  func matchDetail(season: Int, league: String) -> Observable<MatchDetailTable>
  // TODO: - Match detail update
  // func updateMatchDetail()
  
  func standing(season: Int, league: String) -> Observable<StandingsTable>
}
