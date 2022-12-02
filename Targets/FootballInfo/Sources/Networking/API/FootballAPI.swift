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
}

extension FootballAPI: Moya.TargetType {
  var baseURL: URL {
    let stringBaseURL = APIComponents.footBallBaseURL
    return URL(string: stringBaseURL)!
  }
  
  var path: String {
    switch self {
    case .fixture: return "/fixtures"
    }
  }
  
  var method: Moya.Method {
    return .get
  }
  
  var task: Moya.Task {
    switch self {
    case .fixture:
      return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }
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
    }
  }
}
