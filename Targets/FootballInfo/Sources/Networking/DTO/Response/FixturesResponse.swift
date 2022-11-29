//
//  FixtureResponse.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import Foundation

struct FixturesAPIData: Codable {
    var response: [FixturesResponse]
    var results: Int
}

struct FixturesResponse: Codable {
    var fixture: FixturesInfo
    var teams: FixturesTeams
    var goals: FixturesGoals
}

struct FixturesInfo: Codable {
    var id: Int
    var date: String
    var status: FixturesStatus
}

struct FixturesStatus: Codable {
    var short: String
}

struct FixturesTeams: Codable {
    var home: FixturesTeamInfo
    var away: FixturesTeamInfo
}

struct FixturesTeamInfo: Codable {
    var id: Int
    var name: String
    var logo: String
    var winner: Bool?
}

struct FixturesGoals: Codable {
    var home: Int?
    var away: Int?
}
