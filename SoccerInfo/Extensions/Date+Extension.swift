//
//  Date+Extension.swift.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/24.
//

import Foundation
import RealmSwift

extension Date {
    var dayStart: Date {
        return Calendar.CalendarKST.startOfDay(for: self)
    }
    
    // Realm Update Day Hour = 06:00 AM
    var updateHour: Date {
        return Calendar.CalendarKST.date(byAdding: .hour, value: 6, to: self.dayStart)!
    }
    
    var nextDay: Date {
        return Calendar.CalendarKST.date(byAdding: .day, value: 1, to: self.dayStart)!
    }
    
    var fixtureFirstDay: Date {
        return Calendar.CalendarKST.date(byAdding: .day, value: -2, to: self.dayStart)!
    }
    
    // MatchDetail update Day must be bigger than now. MatchDetailTable always load.
    var matchDetailUpdateDay: Date {
        return Calendar.CalendarKST.date(byAdding: .year, value: 1, to: self.dayStart)!
    }
    
    var afterWeekDay: Date {
        return Calendar.CalendarKST.date(byAdding: .day, value: 7, to: self.dayStart)!
    }
    
    var beforeWeekDay: Date {
        return Calendar.CalendarKST.date(byAdding: .day, value: -7, to: self.dayStart)!
    }
    
    var formattedDay: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "en_US")
        formatter.timeZone = TimeZone(abbreviation: "KST")        
        formatter.dateFormat = "yyyy-MM-dd EEEE"
        return formatter.string(from: self)
    }
    
    var formattedHour: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "en_US")
        formatter.timeZone = TimeZone(abbreviation: "KST")        
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
