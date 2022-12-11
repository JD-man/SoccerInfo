//
//  StandingRealmTable.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/11.
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

class StandingsRealmData: EmbeddedObject {
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
