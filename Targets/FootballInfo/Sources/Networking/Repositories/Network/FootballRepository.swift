//
//  FootballRepository.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import Moya
import RxMoya
import RxSwift

final class FootballRepository: FootballRepositoryProtocol {
  private let provider = MoyaProvider<FootballAPI>()
  
  func fixture(season: Int, league: String) -> Observable<FixturesAPIData> {
    let query = FixturesRequestQuery(season: "\(season)", league: league)
    return provider.rx
      .request(.fixture(query: query))
      .asObservable()
      .map(FixturesAPIData.self)
  }
  
  func event(fixtureId: String) -> Observable<EventsAPIData> {
    let query = EventRequestQuery(fixture: fixtureId)
    return provider.rx
      .request(.event(query: query))
      .asObservable()
      .map(EventsAPIData.self)
  }
  
  func lineup(fixtureId: String) -> Observable<LineupsAPIData> {
    let query = LineupRequestQuery(fixture: fixtureId)
    return provider.rx
      .request(.lineup(query: query))
      .asObservable()
      .map(LineupsAPIData.self)
  }
}
