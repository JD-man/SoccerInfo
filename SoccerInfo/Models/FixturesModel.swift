//
//  FixturesModel.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/22.
//

import Foundation
import RealmSwift

// MARK: - Fixtures Realm Model
final class FixturesTable: Object, RealmTable {
    typealias T = List<FixturesRealmData>
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var _partition: String
    @Persisted var season: Int
    @Persisted var updateDate = Date().today
    @Persisted var content: T
    
    convenience init(leagueID: Int, season: Int, fixturesData: List<FixturesRealmData>) {
        self.init()
        self._partition = "\(leagueID)"
        self.season = season
        self.content = fixturesData
    }
}

final class FixturesRealmData: EmbeddedObject {
    @Persisted var fixtureID: Int
    @Persisted var fixtureDate: String
    
    @Persisted var homeID: Int
    @Persisted var homeName: String
    @Persisted var homeLogo: String
    @Persisted var homeGoal: Int?
    
    @Persisted var awayID: Int
    @Persisted var awayName: String
    @Persisted var awayLogo: String
    @Persisted var awayGoal: Int?
    
    convenience init(fixtureResponse: FixturesResponse) {
        self.init()
        let fixture = fixtureResponse.fixture
        self.fixtureID = fixture.id
        self.fixtureDate = fixture.date
        
        let home = fixtureResponse.teams.home
        self.homeID = home.id
        self.homeName = home.name
        self.homeLogo = home.logo
        
        
        let away = fixtureResponse.teams.away
        self.awayID = away.id
        self.awayName = away.name
        self.awayLogo = away.logo
        
        let goals = fixtureResponse.goals
        self.homeGoal = goals.home
        self.awayGoal = goals.away
    }
}

// MARK: - Fixtures Response Model
struct FixturesData: Codable {
    var response: [FixturesResponse]
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
