//
//  DataTypes.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/22.
//

import Foundation
import RealmSwift
import Alamofire

enum FootballData {
    case standings
    case fixtures
    case newsSearch
    case newsImage
    
    var realmTable: Any.Type {
        switch self {
        case .standings:
            return StandingsTable.self
        case .fixtures:
            return FixturesTable.self
        case .newsSearch, .newsImage:
            return NewsResponse.self
        @unknown default:
            print("FootballData realmTable unknown default")
            break
        }
    }
    
    var urlPath: String {
        switch self {
        case .standings:
            return "/standings"
        case .fixtures:
            return "/fixtures"
        case .newsSearch:
            return "/news.json"
        case .newsImage:
            return "/image"
        @unknown default:
            print ("FootballData urlPath unknown default")
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .standings, .fixtures:
            return APIComponents.footBallHeaders
        case .newsImage, .newsSearch:
            return APIComponents.newsHeaders
        @unknown default:
            print("FootballData headers unknown default")
        }
    }
}

enum League: String, CaseIterable {
    case premierLeague = "Premier League"
    case laLiga = "LaLiga"
    case serieA = "Serie A"
    case bundesliga = "Bundesliga"
    case ligue1 = "Ligue 1"
    
    var leagueID: Int {
        switch self {
        case .premierLeague:
            return 39
        case .laLiga:
            return 140
        case .serieA:
            return 135
        case .bundesliga:
            return 78
        case .ligue1:
            return 61
        @unknown default:
            print("league unknown default")
            break
        }
    }
    
    var newsQuery: String {
        switch self {
        case .premierLeague:
            return "프리미어리그"
        case .laLiga:
            return "스페인 라리가"
        case .serieA:
            return "세리에 A"
        case .bundesliga:
            return "분데스리가"
        case .ligue1:
            return "프랑스 리그 1"
        }
    }
}
