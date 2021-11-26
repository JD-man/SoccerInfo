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
            return "프리미어리그 | 첼시 | 맨시티 | 리버풀 | 웨스트햄 | 아스날 | 울버햄튼 | 토트넘 | 맨유"
        case .laLiga:
            return "라리가 | 레알 마드리드 | 아틀레티코 마드리드 | 라요 바예카노 | FC 바르셀로나 | RCD 마요르카 | 발렌시아 CF"
        case .serieA:
            return "세리에 A | SSC 나폴리 | AC 밀란 | FC 인터 밀란 | 아탈란타 BC | AS 로마 | 유벤투스 FC | SS 라치오"
        case .bundesliga:
            return "분데스리가 | FC 바이에른 뮌헨 | 보루시아 도르트문트 | SC 프라이부르크 | | RB 라이프치히 | FSV 마인츠 05 | FC 아우크스부르크"
        case .ligue1:
            return "프랑스 리그 1 | 파리 생제르맹 FC | FC 지롱댕 드 보르도"
        }
    }
}
