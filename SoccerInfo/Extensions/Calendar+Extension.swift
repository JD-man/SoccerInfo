//
//  Calendar+Extension.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/12/05.
//

import Foundation

extension Calendar {
    static var CalendarKST: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "KST")!
        return calendar
    }
}
