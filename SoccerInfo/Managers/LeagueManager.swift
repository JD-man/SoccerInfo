//
//  LeagueManager.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/25.
//

import Foundation

final class LeagueManager {
    private init() {}
    static let shared = LeagueManager()
    
    var league: League = .premierLeague
}
