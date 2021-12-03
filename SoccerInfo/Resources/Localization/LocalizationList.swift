//
//  TeamList.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/12/03.
//

import UIKit

extension UIColor {
    static func teamColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

struct LocalizationList {
    static let team: [Int : (String, [UIColor])] = [
        // Premier League
        33 : ("맨유", [.red, .yellow]),
        34 : ("뉴캐슬", [.black, .white]),
        38 : ("왓포드", [.yellow, .black]),
        39 : ("울버햄튼", [.teamColor(r: 251, g: 209, b: 72), .black]),
        40 : ("리버풀", [.red, .teamColor(r: 117, g: 207, b: 184)]),
        41 : ("사우스햄튼", [.red, .white]),
        42 : ("아스날", [.red, .teamColor(r: 15, g: 44, b: 103)]),
        44 : ("번리", [.teamColor(r: 161, g: 37, b: 104), .teamColor(r: 184, g: 228, b: 240)]),
        45 : ("에버튼", [.teamColor(r: 20, g: 39, b: 155), .white]),
        46 : ("레스터", [.teamColor(r: 33, g: 32, b: 156), .teamColor(r: 253, g: 184, b: 39)]),
        47 : ("토트넘", [.white, .teamColor(r: 22, g: 24, b: 83)]),
        48 : ("웨스트햄", [.teamColor(r: 142, g: 5, b: 5), .teamColor(r: 81, g: 196, b: 233)]),
        49 : ("첼시", [.blue, .white]),
        50 : ("맨시티", [.teamColor(r: 148, g: 218, b: 255), .white]),
        51 : ("브라이튼", [.teamColor(r: 17, g: 60, b: 252), .white]),
        52 : ("크리스탈 팰리스", [.teamColor(r: 52, g: 76, b: 183), .teamColor(r: 249, g: 7, b: 22)]),
        55 : ("브랜트포드", [.teamColor(r: 236, g: 37, b: 90), .teamColor(r: 250, g: 237, b: 240)]),
        63 : ("리즈", [.teamColor(r: 240, g: 201, b: 41), .teamColor(r: 45, g: 70, b: 785)]),
        66 : ("아스톤빌라", [.teamColor(r: 99, g: 0, b: 0), .teamColor(r: 184, g: 228, b: 240)]),
        67 : ("노리치", [.teamColor(r: 0, g: 189, b: 86), .yellow])
        
        // Laliga
        
        // Seria A
        
        // Bundesliga
        
        // Ligue 1
    ]
}
