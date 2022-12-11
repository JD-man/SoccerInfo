//
//  FootballAPI.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import Foundation
import Moya

enum FootballAPI {
  case fixture(query: FixturesRequestQuery)
  case event(query: EventRequestQuery)
  case lineup(query: LineupRequestQuery)
  case standing(query: StandingRequestQuery)
}

extension FootballAPI: Moya.TargetType {
  var baseURL: URL {
    let stringBaseURL = APIComponents.footBallBaseURL
    return URL(string: stringBaseURL)!
  }
  
  var path: String {
    switch self {
    case .fixture: return "/fixtures"
    case .event: return "/fixtures/events"
    case .lineup: return "/fixtures/lineups"
    case .standing: return "/standings"
    }
  }
  
  var method: Moya.Method {
    return .get
  }
  
  var task: Moya.Task {
    return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
  }
  
  var headers: [String : String]? {
    return APIComponents.footBallHeaders
  }
  
  var parameters: [String: String] {
    switch self {
    case .fixture(let query):
      return [
        "season": query.season,
        "league": query.league
      ]
    case .event(let query):
      return [
        "fixture": query.fixture
      ]
      
    case .lineup(let query):
      return [
        "fixture": query.fixture
      ]
    case .standing(let query):
      return [
        "season": query.season,
        "league": query.league
      ]
    }
  }
}
