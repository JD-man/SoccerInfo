//
//  DateFormatter+Extension.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2022/01/15.
//

import Foundation

extension DateFormatter {
    static func KST(dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "en_US")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = dateFormat
        return formatter
    }
}
