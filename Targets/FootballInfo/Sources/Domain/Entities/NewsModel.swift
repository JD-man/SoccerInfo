//
//  NewsModel.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/26.
//

import Foundation

struct NewsResponse: Codable {
    var total: Int
    var items: [NewsData]
}

struct NewsData: Codable {
    var title: String?
    var link: String?
    var description: String?
    var pubDate: String?
    var imageURL: String?
}
