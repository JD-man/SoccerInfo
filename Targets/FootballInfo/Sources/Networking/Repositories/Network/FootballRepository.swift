//
//  FootballRepository.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import Moya
import RxMoya
import RxSwift

protocol FootballRepositoryProtocol: AnyObject {
  func fixture(season: Int, league: String) -> Observable<FixturesAPIData>
}

final class FootballRepository: FootballRepositoryProtocol {
  private let proivder = MoyaProvider<FootballAPI>()
  
  func fixture(season: Int, league: String) -> Observable<FixturesAPIData> {
    let query = FixturesRequestQuery(season: "\(season)", league: league)
    return proivder.rx
      .request(.fixture(query: query))
      .asObservable()
      .map(FixturesAPIData.self)
  }
}
