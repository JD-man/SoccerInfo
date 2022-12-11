//
//  StandingResponse.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/11.
//

import Foundation

// MARK: - Standings Response Model
struct StandingAPIData: Codable {
    var response: [StandingResponse]
    var results: Int
}

struct StandingResponse: Codable {
    var league: StandingLeague
}

struct StandingLeague: Codable {
    var id: Int
    var season: Int
    var standings: [[Standings]]
}

struct Standings: Codable {
    var rank: Int
    var team: StandingTeam
    var points: Int
    var goalsDiff: Int
    var all: StandingStatus
}

struct StandingTeam: Codable {
    var id: Int
    var name: String
    var logo: String
}

struct StandingStatus: Codable {
    var played: Int
    var win: Int
    var draw: Int
    var lose: Int
}
