//
//  MatchDetailModel.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/27.
//

import Foundation
import RealmSwift

// MARK: - Match Detail Realm Data Model
final class MatchDetailTable: Object, RealmTable {
    typealias T = List<MatchDetailRealmData>
    @Persisted var _partition: String
    @Persisted var season: Int
    @Persisted var updateDate = Date().dayStart
    @Persisted var content: T
}

// events, lineup of 1 fixtures
final class MatchDetailRealmData: EmbeddedObject, BasicTabViewData {
    @Persisted var fixtureID: Int
    @Persisted var events: List<EventsRealmData>
    @Persisted var homeTeamLineup: List<LineupRealmData>
    @Persisted var awayTeamLineup: List<LineupRealmData>
}

final class EventsRealmData: EmbeddedObject {
    @Persisted var time: Int
    @Persisted var player: String
    @Persisted var assist: String?
    @Persisted var eventType: String
    @Persisted var eventDetail: String
}

final class LineupRealmData: EmbeddedObject {
    @Persisted var name: String
    @Persisted var number: Int
    @Persisted var position: String
    @Persisted var grid: String?
}

// MARK: - Events Response Model
struct EventsAPIData: Codable {
    var response: [EventsResponse]
}

struct EventsResponse: Codable {
    var time: EventsTime
    var player: EventsPlayer
    var assist: EventsAssist
    var type: String
    var detail: String
}

struct EventsTime: Codable {
    var elapsed: Int
    var extra: Int?
}

struct EventsPlayer: Codable {
    var name: String
}

struct EventsAssist: Codable {
    var name: String?
}

// MARK: - Lineups Response Model
struct LineupsAPIData: Codable {
    var response: [LineupsResponse]
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
    var name: String
    var number: Int
    var pos: String
    var grid: String?
}
