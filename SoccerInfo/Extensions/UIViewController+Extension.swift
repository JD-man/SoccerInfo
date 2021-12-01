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
    func fetchRealmData<T: RealmTable>(league: League, season: Int, completion: @escaping (Result<T, RealmErrorType>) -> Void ) {
        let app = App(id: APIComponents.realmAppID)
        guard let user = app.currentUser else {
            alertWithCheckButton(title: "서버 접속에 실패했습니다",
                                 message: "네트워크 연결 상태를 확인하고 다시 시도해주세요.",
                                 completion: nil)
            return }
        print("FetchRealmData", user)
        let configuration = user.configuration(partitionValue: "\(league.leagueID)")
        do {
            // Local Realm Load
            print("Local Realm Load")
            let localRealm = try Realm(configuration: configuration)
            
            // check league, season, updateDate
            let objects = localRealm.objects(T.self).where {
                $0._partition == "\(league.leagueID)" &&
                $0.season == season &&
                $0.updateDate > Date()
            }
            if objects.isEmpty {
                // Cloud Realm Load
                print("Cloud Realm Load")
                Realm.asyncOpen(configuration: configuration) { result in
                    switch result {
                    case .success(let realm):
                        let syncedObjects = realm.objects(T.self).where {
                            $0._partition == "\(league.leagueID)" &&
                            $0.season == season &&
                            $0.updateDate > Date()
                        }
                        if syncedObjects.isEmpty {
                            completion(.failure(.emptyData))
                        }                        
                        else {
                            completion(.success(syncedObjects.first!))
                        }
                        print("Cloud Realm Loaded")
                    case .failure(let error):
                        print("sync realm error", error)
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
            print("realm fail", error)
            completion(.failure(.realmFail))
        }
    }
    
    func updateRealmData<T: RealmTable>(table: T, leagueID: Int, season: Int) {
        let app = App(id: APIComponents.realmAppID)
        guard let user = app.currentUser else {
            alertWithCheckButton(title: "서버 접속에 실패했습니다",
                                 message: "네트워크 연결 상태를 확인하고 다시 시도해주세요.",
                                 completion: nil)
            return }
        let configuration = user.configuration(partitionValue: "\(leagueID)")
        
        
        Realm.asyncOpen(configuration: configuration) { result in
            switch result {
            case .success(let realm):
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
                            // if both count is not same, content is List Type. Need append
                            let prevObject = object.first!
                            if prevObject.content.count == table.content.count {
                                prevObject.content = table.content
                            }
                            else {
                                prevObject.content.append(table.content.last!)
                            }
                            
                            // Setting New Realm Update Date
                            let now = Date()
                            let newUpdateDate = table.updateDate // already 06:00 AM
                            
                            // same day. now start == newUpdateDate start update day become nextday 06:00
                            if now.dayStart == newUpdateDate.dayStart {
                                prevObject.updateDate = newUpdateDate.nextDay.updateHour
                            }
                            // other day before 06:00 AM. now < newUpdateDate
                            else if now < newUpdateDate {
                                prevObject.updateDate = newUpdateDate
                            }
                            // other day after 06:00 AM
                            else if now >= newUpdateDate {
                                prevObject.updateDate = newUpdateDate.nextDay.updateHour
                            }
                            
                            print("Realm Upload complete")
                        }
                    })
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print("sync realm error", error)
            }
        }
    }
    
    func loginRealm() {
        let app = App(id: APIComponents.realmAppID)
        app.login(credentials: .anonymous) { result in
            switch result {
            case .success(let user):
                print("SceneDelegate", user.id)
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - extension with Alamofire
extension UIViewController {
    func fetchAPIData<T: Codable>(of footBallData: FootballData, url: URL?, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            print("url fail")
            return            
        }
        AF.request(url, method: .get, headers: footBallData.headers).validate().responseJSON { [weak self] response in
            switch response.result {
            case .success(_):
                guard let data = response.data,
                      let decoded = try? JSONDecoder().decode(T.self, from: data) else {
                          print("decode fail")
                          return }                
                completion(.success(decoded))
                print("API CALL")
            case .failure(let error):
                self?.alertWithCheckButton(title: "데이터를 가져오는데 실패했습니다",
                                           message: "네트워크 연결 상태를 확인해주세요.",
                                           completion: nil)
                print(error)
            }
        }
    }
}

// MARK: - extension for activity indicator
extension UIViewController {
    func activityIndicator() -> UIActivityIndicatorView {
        let activityIndicator: UIActivityIndicatorView = {
            let activityView = UIActivityIndicatorView()
            activityView.hidesWhenStopped = true
            activityView.backgroundColor = .clear
            activityView.style = .large
            return activityView
        }()
        
        self.view.addSubview(activityIndicator)
        activityIndicator.frame = self.view.bounds
        return activityIndicator
    }
}

// MARK: - extension for alert
extension UIViewController {
    func alertWithCheckButton(title: String, message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
            if let completion = completion { completion() }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func alertWithSettingURL(title: String, message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
            if let completion = completion { completion() }
        }))
        alert.addAction(UIAlertAction(title: "설정", style: .default, handler: { _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingURL) {
                UIApplication.shared.open(settingURL, options: [:], completionHandler: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
