////
////  DataTypes.swift
////  SoccerInfo
////
////  Created by JD_MacMini on 2021/11/22.
////
//
//import Foundation
//import RealmSwift
//import Alamofire
//import UIKit
//
//enum FootballData {
//    case standings(season: Int, league: League)
//    case fixtures(season: Int, league: League)
//    case events(fixtureID: Int)
//    case lineups(fixtureID: Int)
//    case newsSearch(start: Int, display: Int, league: League)
//    case newsImage(sort: String, display: Int, query: String)
//    
//    var realmTable: Any.Type {
//        switch self {
//        case .standings:
//            return StandingsTable.self
//        case .fixtures:
//            return FixturesTable.self
//        case .events, .lineups:
//            return MatchDetailTable.self
//        case .newsSearch, .newsImage:
//            return NewsResponse.self
//        @unknown default:
//            print("FootballData realmTable unknown default")
//            break
//        }
//    }
//    
//    var rootURL: String {
//        switch self {
//        case .standings, .fixtures, .events, .lineups:
//            return "" //APIComponents.footBallRootURL
//        case .newsSearch, .newsImage:
//            return APIComponents.newsRootURL
//        }
//    }
//    
//    var urlPath: String {
//        switch self {
//        case .standings:
//            return "/standings"
//        case .fixtures:
//            return "/fixtures"
//        case .events:
//            return "/fixtures/events"
//        case .lineups:
//            return "/fixtures/lineups"
//        case .newsSearch:
//            return "/news.json"
//        case .newsImage:
//            return "/image"
//        @unknown default:
//            print ("FootballData urlPath unknown default")
//        }
//    }
//    
//    var queryItems: [URLQueryItem]? {
//        switch self {
//        case .standings(let season, let league):
//            let season = URLQueryItem(name: "season", value: "\(season)")
//            let league = URLQueryItem(name: "league", value: "\(league.leagueID)")
//            return [season, league]
//        case .fixtures(let season, let league):
//            let season = URLQueryItem(name: "season", value: "\(season)")
//            let league = URLQueryItem(name: "league", value: "\(league.leagueID)")
//            return [season, league]
//        case .events(let fixtureID):
//            let fixture = URLQueryItem(name: "fixture", value: "\(fixtureID)")
//            return [fixture]
//        case .lineups(let fixtureID):
//            let fixture = URLQueryItem(name: "fixture", value: "\(fixtureID)")
//            return [fixture]
//        case .newsSearch(let start, let display, let league):
//            let start = URLQueryItem(name: "start", value: "\(start)")
//            let display = URLQueryItem(name: "display", value: "\(display)")
//            let query = URLQueryItem(name: "query", value: "\(league.newsQuery)")
//            return [start, display, query]
//        case .newsImage(let sort, let display, let query):
//            let sort = URLQueryItem(name: "sort", value: sort)
//            let display = URLQueryItem(name: "display", value: "\(display)")
//            let query = URLQueryItem(name: "query", value: query.removeSearchTag)
//            return [sort, display, query]
//        @unknown default:
//            print("queryItems unknown default")
//        }
//    }
//    
//    var headers: HTTPHeaders {
//        switch self {
//        case .standings, .fixtures , .events, .lineups:
//          return [:]//APIComponents.footBallHeaders
//        case .newsImage, .newsSearch:
//          return [:]//APIComponents.newsHeaders
//        @unknown default:
//            print("FootballData headers unknown default")
//        }
//    }
//}
