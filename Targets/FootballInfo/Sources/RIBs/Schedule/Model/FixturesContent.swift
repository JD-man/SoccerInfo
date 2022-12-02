//
//  FixturesModel.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/22.
//

import Foundation

struct FixturesContent {
    let homeID: Int
    let homeName: String
    let homeLogo: String
    var homeGoal: Int?
    
    let awayID: Int
    let awayName: String
    let awayLogo: String
    var awayGoal: Int?
    
    let matchHour: String
    let fixtureID: Int
    
    static let initialContent = FixturesContent(homeID: 0,
                                                homeName: "",
                                                homeLogo: "",
                                                homeGoal: nil,
                                                awayID: 0,
                                                awayName: "",
                                                awayLogo: "",
                                                awayGoal: nil,
                                                matchHour: "",
                                                fixtureID: 0)
}
