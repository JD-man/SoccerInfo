//
//  Standings.swift.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/18.
//

import Foundation
import RealmSwift

/*
 {
    "title": "StandingsTable",
    "bsonType": "object",
    "required": [
      "_id",
      "_partition",
      "season",
      "updateDate"
    ],
    "properties": {
      "_id": {
        "bsonType": "objectId"
      },
      "_partition": {
        "bsonType": "string"
      },
      "season": {
        "bsonType": "int"
      },
      "standingData": {
        "bsonType": "array",
        "items": {
          "title": "StandingsRealmData",
          "bsonType": "object",
          "required": [
            "teamName",
            "teamLogo",
            "teamID",
            "played",
            "points",
            "win",
            "draw",
            "lose"
          ],
          "properties": {
              "teamName": {
                  "bsonType": "string"
              },
              "teamLogo": {
                  "bsonType": "string"
              },
              "teamID": {
                  "bsonType": "int"
              },
              "played": {
                  "bsonType": "int"
              },
              "points": {
                  "bsonType": "int"
              },
              "win": {
                  "bsonType": "int"
              },
              "draw": {
                  "bsonType": "int"
              },
              "lose": {
                  "bsonType": "int"
              }
          }
        }
      },
      "updateDate": {
        "bsonType": "date"
      }
    }
  }
 */


// Realm Data

class StandingsTable: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var _partition: String
    @Persisted var season: Int
    @Persisted var standingData: List<StandingsRealmData>
    @Persisted var updateDate = Date()

    convenience init(leagueID: Int, season: Int, standingData: List<StandingsRealmData>) {
        self.init()
        self._partition = "\(leagueID)"
        self.season = season
        self.standingData = standingData
    }
}

class StandingsRealmData: EmbeddedObject {
    //@Persisted(primaryKey: true) var _id: ObjectId
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


/*
 {
   "title": "StandingsTable",
   "bsonType": "object",
   "required": [
     "_id",
     "_partition",
     "season",
     "updateDate"
   ],
   "properties": {
     "_id": {
       "bsonType": "objectId"
     },
     "_partition": {
       "bsonType": "string"
     },
     "season": {
       "bsonType": "long"
     },
     "standingData": {
       "bsonType": "array",
       "items": {
         "title": "StandingsRealmData",
         "bsonType": "object",
         "required": [
           "teamName",
           "teamLogo",
           "teamID",
           "played",
           "points",
           "win",
           "draw",
           "lose"
         ],
         "properties": {
           "teamName": {
             "bsonType": "string"
           },
           "teamLogo": {
             "bsonType": "string"
           },
           "teamID": {
             "bsonType": "long"
           },
           "played": {
             "bsonType": "long"
           },
           "points": {
             "bsonType": "long"
           },
           "win": {
             "bsonType": "long"
           },
           "draw": {
             "bsonType": "long"
           },
           "lose": {
             "bsonType": "long"
           }
         }
       }
     },
     "updateDate": {
       "bsonType": "date"
     }
   }
 }
 */
