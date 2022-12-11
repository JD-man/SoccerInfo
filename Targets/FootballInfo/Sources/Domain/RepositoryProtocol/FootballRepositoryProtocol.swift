//
//  FootballRepositoryProtocol.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/10.
//

import Foundation
import RxSwift

protocol FootballRepositoryProtocol: AnyObject {
  func fixture(season: Int, league: String) -> Observable<FixturesAPIData>
  func event(fixtureId: String) -> Observable<EventsAPIData>
  func lineup(fixtureId: String) -> Observable<LineupsAPIData>
}
