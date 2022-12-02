//
//  LeagueManager.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/25.
//

import Foundation

final class PublicPropertyManager {
    private init() {}
    static let shared = PublicPropertyManager()
    
  var league: LeagueInfo.League = .premierLeague
    var season: Int = 2022
}
