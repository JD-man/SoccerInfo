//
//  DataTypes.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/22.
//

import Foundation
import RealmSwift

enum FootballData {
    case standings
    
    var realmTable: Object.Type {
        switch self {
        case .standings:
            return StandingsTable.self
        @unknown default:
            print("unknown default")
            break
        }
    }
}
