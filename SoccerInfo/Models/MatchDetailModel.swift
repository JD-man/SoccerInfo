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
    typealias T = MatchDetailRealmData
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var _partition: String
    @Persisted var season: Int
    @Persisted var updateDate = Date().matchDetailUpdateDay.updateHour
    @Persisted var content: List<T>
    
    convenience init(leagueID: Int, season: Int, content: List<MatchDetailRealmData>) {
        self.init()
        self._partition = "\(leagueID)"
        self.season = season
        self.content = content
    }
}

// events, lineup of 1 fixtures
final class MatchDetailRealmData: EmbeddedObject {
    @Persisted var fixtureID: Int
    @Persisted var events: List<EventsRealmData>
    @Persisted var homeStartLineup: List<LineupRealmData>
    @Persisted var homeSubLineup: List<LineupRealmData>
    @Persisted var homeFormation: String
    @Persisted var awayStartLineup: List<LineupRealmData>
    @Persisted var awaySubLineup: List<LineupRealmData>
    @Persisted var awayFormation: String
    
    convenience init(fixtureID: Int, events: List<EventsRealmData>,
                     homeStartLineup: List<LineupRealmData>, homeSubLineup: List<LineupRealmData>,
                     awayStartLineup: List<LineupRealmData>, awaySubLineup: List<LineupRealmData>,
                     homeFormation: String, awayFormation: String) {
        self.init()
        self.fixtureID = fixtureID
        self.events = events
        self.homeStartLineup = homeStartLineup
        self.homeSubLineup = homeSubLineup
        self.homeFormation = homeFormation
        self.awayStartLineup = awayStartLineup
        self.awaySubLineup = awaySubLineup
        self.awayFormation = awayFormation
    }
    
    static let initialValue = MatchDetailRealmData(fixtureID: 0,
                                                   events: List<EventsRealmData>(),
                                                   homeStartLineup: List<LineupRealmData>(),
                                                   homeSubLineup: List<LineupRealmData>(),
                                                   awayStartLineup: List<LineupRealmData>(),
                                                   awaySubLineup: List<LineupRealmData>(),
                                                   homeFormation: "",
                                                   awayFormation: "")
}

final class EventsRealmData: EmbeddedObject {
    @Persisted var time: Int
    @Persisted var teamName: String
    @Persisted var player: String
    @Persisted var assist: String?
    @Persisted var eventType: String
    @Persisted var eventDetail: String
    
    convenience init(eventsResponse: EventsResponse) {
        self.init()
        self.time = eventsResponse.time.elapsed + (eventsResponse.time.extra ?? 0)
        self.teamName = eventsResponse.team.name
        self.player = eventsResponse.player.name
        self.assist = eventsResponse.assist.name
        self.eventType = eventsResponse.type
        self.eventDetail = eventsResponse.detail
    }
}

final class LineupRealmData: EmbeddedObject {
    @Persisted var name: String
    @Persisted var number: Int
    @Persisted var position: String
    @Persisted var grid: String?
    
    convenience init(lineupsPlayer: LineupsPlayer) {
        self.init()
        self.name = lineupsPlayer.name
        self.number = lineupsPlayer.number
        self.position = lineupsPlayer.pos
        self.grid = lineupsPlayer.grid
    }
}

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
