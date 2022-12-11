//
//  LineupResponse.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/06.
//

import Foundation

// MARK: - Lineups Response Model
struct LineupsAPIData: Codable {
    var response: [LineupsResponse]
    var results: Int
}

struct LineupsResponse: Codable {
    var formation: String
    var startXI: [LineupsStartXI]
    var substitutes: [LineupsSubs]
}

struct LineupsStartXI: Codable {
    var player: LineupsPlayer
}

struct LineupsSubs: Codable {
    var player: LineupsPlayer
}

struct LineupsPlayer: Codable {
    var id: Int?
    var name: String
    var number: Int
    var pos: String
    var grid: String?
}
