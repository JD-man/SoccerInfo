//
//  Errors.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/22.
//

import Foundation

enum RealmErrorType: Error {
    case emptyData    
    case asyncOpenFail
    case realmFail
}

enum APIErrorType: Error {
    case requestLimit
    case timeout    
    case serverError
}

/* Football API Error
 200 : OK, Request Limit(??)
 499 : Time Out
 500 : Server Error
*/


/* Naver Search API
 429 : Request Limit
 500 : Server Error
 */
