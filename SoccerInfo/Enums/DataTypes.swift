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
    
    var realmTable: Object.Type {
        switch self {
        case .standings:
            return StandingsTable.self
        case .fixtures:
            return FixturesTable.self
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
        @unknown default:
            print("FootballData urlPath unknown default")
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .standings, .fixtures:
            return APIComponents.footBallHeaders
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
}
