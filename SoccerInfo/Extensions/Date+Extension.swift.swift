//
//  Date+Extension.swift.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/24.
//

import Foundation
import RealmSwift

extension Date {
    var today: Date {
        return Calendar.current.startOfDay(for: self)
    }
    var nextDay: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    var formattedDay: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first!)
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: self)
    }
    
    var formattedHour: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first!)
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
