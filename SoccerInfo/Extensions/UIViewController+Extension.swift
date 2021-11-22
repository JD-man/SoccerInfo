//
//  UIViewController+Extension.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/22.
//

import UIKit
import Realm
import RealmSwift

// extension with realm
extension UIViewController {
    func fetchRealmData<T: Object>(table: T.Type, league: Int, completion: @escaping (Result<T, Error>) -> Void ) {
        let app = App(id: APIComponents.realmAppID)
        if let user = app.currentUser {
            let configuration = user.configuration(partitionValue: "\(league)")
            do {
                // Local Realm Load
                let localRealm = try Realm(configuration: configuration)
                let objects = localRealm.objects(T.self)
                
                // Cloud Realm Load
                if objects.isEmpty {
                    Realm.asyncOpen(configuration: configuration) { result in
                        switch result {
                        case .success(let realm):
                            let syncedObjects = realm.objects(T.self)
                            completion(.success(syncedObjects.first!))
                            print("Cloud Realm Loaded")
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
                else {
                    completion(.success(objects.first!))
                    print("Local Realm loaded")
                }
                
            }
            catch {
                completion(.failure(error))
            }
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
