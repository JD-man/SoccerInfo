//
//  String+Extension.swift.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/23.
//

import Foundation
import UIKit

extension String {
    func toURL(of dataType: FootballData, queryItems: [URLQueryItem]) -> URL? {
        var components = URLComponents(string: self + dataType.urlPath)
        components?.queryItems = queryItems        
        return components?.url
    }
    
    // for fixture date
    var toDate: Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first!)
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        
        // 2021-11-28T23:00:00+09:00
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return formatter.date(from: self) ?? Date()
    }
    
    // for Fixture title to Date
    var sectionTitleToDate: Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first!)
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        
        formatter.dateFormat = "yyyy-MM-dd EEEE"
        
        return formatter.date(from: self) ?? Date()
    }
    
    // for news search
    var removeSearchTag: String {
        return self.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
            .replacingOccurrences(of: "&quot", with: "").replacingOccurrences(of: ";", with: "")
    }
    
    // for Removing " " of team name
    
    var modifyTeamName: String {
        return self.replacingOccurrences(of: " ", with: "\n")
    }
    
    // emoji to image
    func image() -> UIImage? {
        let size = CGSize(width: 100, height: 100)
        let rect = CGRect(origin: .zero, size: size)
        return UIGraphicsImageRenderer(size: size).image { context in
            (self as NSString).draw(in: rect, withAttributes: [.font : UIFont.systemFont(ofSize: 80)])
        }
    }
}
