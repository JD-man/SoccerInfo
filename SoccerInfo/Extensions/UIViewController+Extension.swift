//
//  UIViewController+Extension.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/22.
//

import UIKit
import RealmSwift
import Alamofire
import SideMenu

//MARK: - extension with realm
extension UIViewController {
    // T is determined when ViewController declare typealias
    func fetchRealmData<T: RealmTable>(league: League, season: Int = 2021, completion: @escaping (Result<T, RealmErrorType>) -> Void ) {
        let app = App(id: APIComponents.realmAppID)
        guard let user = app.currentUser else { return }
        let configuration = user.configuration(partitionValue: "\(league.leagueID)")
        do {
            // Local Realm Load
            let localRealm = try Realm(configuration: configuration)
            let today = Date().today
            
            // check league, season, updateDate
            let objects = localRealm.objects(T.self).where {
                $0._partition == "\(league.leagueID)" &&
                $0.season == season &&
                $0.updateDate >= today &&
                $0.updateDate < today.nextDay
            }
            if objects.isEmpty {
                // Cloud Realm Load
                Realm.asyncOpen(configuration: configuration) { result in
                    switch result {
                    case .success(let realm):
                        let syncedObjects = realm.objects(T.self).where {
                            $0._partition == "\(league.leagueID)" &&
                            $0.season == season &&
                            $0.updateDate >= today &&
                            $0.updateDate < today.nextDay
                        }
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
    
    func updateRealmData<T: RealmTable>(table: T, leagueID: Int, season: Int = 2021) {
        let app = App(id: APIComponents.realmAppID)
        guard let user = app.currentUser else { return }
        let configuration = user.configuration(partitionValue: "\(leagueID)")
        
        Realm.asyncOpen(configuration: configuration) { result in
            switch result {
            case .success(let realm):
                print(realm.configuration.fileURL)
                do {
                    // check league, season
                    let object = realm.objects(T.self).where {
                        $0._partition == "\(leagueID)" && $0.season == season
                    }
                    try realm.write({
                        if object.isEmpty {
                            realm.add(table)
                        }
                        else {
                            print("change data")
                            let prevObject = object.first!
                            prevObject.content = table.content
                            prevObject.updateDate = table.updateDate
                        }
                    })
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // delete for test
    func deleteRealmDataAll() {
        let app = App(id: APIComponents.realmAppID)
        guard let user = app.currentUser else { return }
        let configuration = user.configuration(partitionValue: "39")
        
        Realm.asyncOpen(configuration: configuration) { result in
            switch result {
            case .success(let realm):
                print(realm.configuration.fileURL)
                do {
                    try realm.write({
                        realm.deleteAll()
                    })
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
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

//MARK: - extension with Alamofire
extension UIViewController {
    func fetchAPIData<T: Codable>(of footBallData: FootballData, url: URL?, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else { return }
        AF.request(url, method: .get, headers: footBallData.headers).validate().responseJSON { response in
            switch response.result {
            case .success(_):
                guard let data = response.data,
                      let decoded = try? JSONDecoder().decode(T.self, from: data) else { return }
                completion(.success(decoded))
            case .failure(let error):
                print(error)
            }
        }
    }
}
