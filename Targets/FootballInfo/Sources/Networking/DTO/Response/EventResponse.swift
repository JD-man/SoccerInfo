//
//  EventResponse.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/06.
//

import Foundation

// MARK: - Events Response Model
struct EventsAPIData: Codable {
    var response: [EventsResponse]
    var results: Int
}

struct EventsResponse: Codable {
    var time: EventsTime
    var team: EventsTeam
    var player: EventsPlayer
    var assist: EventsAssist
    var type: String
    var detail: String
}

struct EventsTime: Codable {
    var elapsed: Int
    var extra: Int?
}

struct EventsTeam: Codable {
    var name: String
}

struct EventsPlayer: Codable {
    var id: Int?
    var name: String
}

struct EventsAssist: Codable {
    var id: Int?
    var name: String?
}
