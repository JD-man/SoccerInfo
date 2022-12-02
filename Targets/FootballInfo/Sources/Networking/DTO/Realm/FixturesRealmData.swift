//
//  FixtureRealmData.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import Foundation
import RealmSwift

// MARK: - Fixtures Realm Model
final class FixturesTable: Object, RealmTable {
    typealias T = FixturesRealmData
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var _partition: String
    @Persisted var season: Int
    @Persisted var updateDate = Date().updateHour
    @Persisted var content: List<T>
    
    convenience init(leagueID: Int, season: Int, fixturesData: List<FixturesRealmData>) {
        self.init()
        self._partition = "\(leagueID)"
        self.season = season
        self.content = fixturesData
    }
}

// Domain Entity
final class FixturesRealmData: EmbeddedObject, BasicTabViewData {
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
