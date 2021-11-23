//
//  String+Extension.swift.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/23.
//

import Foundation

extension String {
    func toURL(of dataType: FootballData, queryItems: [URLQueryItem]) -> URL? {
        var components = URLComponents(string: self + dataType.urlPath)
        components?.queryItems = queryItems        
        return components?.url
    }
}
