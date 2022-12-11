//
//  FootballRealmRepository.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import Foundation
import RealmSwift
import RxSwift

final class FootballRealmRepository: FootballRealmRepositoryProtocol {
  
  private let provider = RealmProvider()
}

// MARK: - Fixture
extension FootballRealmRepository {
  func fixture(season: Int, league: String) -> Observable<FixturesTable> {
    let query = RealmQuery(season: season, league: league)
    return provider.fetchRealmData(query: query)
  }
  
  func updateFixture(fixturesData: [FixturesRealmData], season: Int, league: String) {
    let query = RealmQuery(season: season, league: league)
    let list = List<FixturesRealmData>()
    fixturesData.forEach { list.append($0) }
    let table = FixturesTable(leagueID: Int(query.league) ?? 0,
                              season: query.season,
                              fixturesData: list)
    provider.updateRealmData(table: table, query: query)
  }
}

// MARK: - Match Detail
extension FootballRealmRepository {
  func matchDetail(season: Int, league: String) -> Observable<MatchDetailTable> {
    let query = RealmQuery(season: season, league: league)
    return provider.fetchRealmData(query: query)
  }
}
