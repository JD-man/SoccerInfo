//
//  Standings.swift.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/18.
//

import Foundation
import RealmSwift

protocol RealmTable: Object {
    associatedtype T: EmbeddedObject
    var _partition: String { get set }
    var season: Int { get }
    var updateDate: Date { get set}
    var content: List<T> { get set }
}

// empty protocol for generic BasicTabViewController
protocol BasicTabViewData { }


// MARK: - Standings Realm Model
class StandingsTable: Object, RealmTable {
    typealias T = StandingsRealmData
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var _partition: String // leagueID
    @Persisted var season: Int
    @Persisted var content: List<T>
    @Persisted var updateDate = Date().updateHour

    convenience init(leagueID: Int, season: Int, standingData: List<StandingsRealmData>) {
        self.init()
        self._partition = "\(leagueID)"
        self.season = season
        self.content = standingData
    }
}

class StandingsRealmData: EmbeddedObject, BasicTabViewData {
    @Persisted var rank: Int
    @Persisted var teamName: String
    @Persisted var teamLogo: String
    @Persisted var teamID: Int
    @Persisted var played: Int
    @Persisted var points: Int
    @Persisted var win: Int
    @Persisted var draw: Int
    @Persisted var lose: Int
    @Persisted var goalsDiff: Int
    
    convenience init(standings: Standings) {
        self.init()
        self.rank = standings.rank
        self.teamName = standings.team.name
        self.teamLogo = standings.team.logo
        self.teamID = standings.team.id
        self.played = standings.all.played
        self.points = standings.points
        self.win = standings.all.win
        self.draw = standings.all.draw
        self.lose = standings.all.lose
        self.goalsDiff = standings.goalsDiff
    }
}
    

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

//struct FootBallAPIRequestError: Codable {
//    var requests: String
//}
