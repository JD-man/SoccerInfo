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
