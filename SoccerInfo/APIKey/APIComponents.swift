//
//  APIComponents.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/21.
//

import Foundation
import Alamofire

struct APIComponents {
    static let realmAppID: String = "jdssoccerinfo-mhwgc"
    
    static let footBallRootURL: String = "https://v3.football.api-sports.io"
    static let footBallHeaders: HTTPHeaders = [
        "x-rapidapi-host" : "v3.football.api-sports.io",
        "x-apisports-key" : "88ce78a5392ae4d38d35e78055d81a9b"
    ]
    
    static let newsRootURL: String = "https://openapi.naver.com/v1/search"    
    static let newsHeaders: HTTPHeaders = [
        "X-Naver-Client-Id" : "KLk9K5n8nqxtIzA7RZLq",
        "X-Naver-Client-Secret" : "bhc3LUmNHq"
    ]
}
