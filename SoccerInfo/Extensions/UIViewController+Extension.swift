//
//  UIViewController+Extension.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/22.
//

import UIKit
import RealmSwift
import Alamofire

//MARK: - extension with realm
extension UIViewController {
    // T is determined when ViewController declare typealias
    func fetchRealmData<T: RealmTable>(league: Int, completion: @escaping (Result<T, RealmErrorType>) -> Void ) {
        let app = App(id: APIComponents.realmAppID)
        guard let user = app.currentUser else { return }
        let configuration = user.configuration(partitionValue: "\(league)")
        do {
            // Local Realm Load
            let localRealm = try Realm(configuration: configuration)
            let objects = localRealm.objects(T.self).where {
                $0.season == 2021
            }
            
            // Cloud Realm Load
            if objects.isEmpty {
                Realm.asyncOpen(configuration: configuration) { result in
                    switch result {
                    case .success(let realm):
                        let syncedObjects = realm.objects(T.self)
                        if syncedObjects.isEmpty {
                            completion(.failure(.emptyData))
                        }
                        else {
                            completion(.success(syncedObjects.first!))
                        }
                        print("Cloud Realm Loaded")
                    case .failure(let error):
                        print(error)
                        completion(.failure(.asyncOpenFail))
                    }
                }
            }
            else {
                completion(.success(objects.first!))
                print("Local Realm loaded")
            }
        }
        catch {
            print(error)
            completion(.failure(.realmFail))
        }
    }

    
    func loginRealm() {
        let app = App(id: APIComponents.realmAppID)
        guard let username = UIDevice.current.identifierForVendor else {
            // alert
            print("ID for Vender is nil")
            return
        }
        let params: Document = ["username" : AnyBSON(stringLiteral: username.uuidString)]
        
        app.login(credentials: Credentials.function(payload: params)) { result in
            switch result {
            case .success(let user):
                print(user.id)
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - extension with Alamofire
extension UIViewController {
    func fetchAPIData() {
        
    }
}
