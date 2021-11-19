//
//  Standings.swift.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/18.
//

import Foundation
import RealmSwift

// Realm Data

class StandingsTable: Object {
    @Persisted(primaryKey: true) var id = ObjectId()
    @Persisted var data: List<StandingsRealmData>

    convenience init(data: List<StandingsRealmData>) {
        self.init()
        self.data = data
    }
}

class StandingsRealmData: Object {
    @Persisted var teamName: String
    @Persisted var teamLogo: String
    @Persisted var teamID: Int
    @Persisted var played: Int
    @Persisted var points: Int
    @Persisted var win: Int
    @Persisted var draw: Int
    @Persisted var lose: Int
    
    convenience init(standings: Standings) {
        self.init()
        self.teamName = standings.team.name
        self.teamLogo = standings.team.logo
        self.teamID = standings.team.id
        self.played = standings.all.played
        self.points = standings.points
        self.win = standings.all.win
        self.draw = standings.all.draw
        self.lose = standings.all.lose
    }
}
    

// Response By API
struct StandingData: Codable {
    var response: [StandingResponse]
}

struct StandingResponse: Codable {
    var league: StandingLeague
}

struct StandingLeague: Codable {
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
