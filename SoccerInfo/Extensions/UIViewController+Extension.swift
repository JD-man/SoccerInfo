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
            return            
        }
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
                Realm.asyncOpen(configuration: configuration) { [weak self] result in
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
                        self?.alertWithCheckButton(title: "Error Code : 1", message: "", completion: nil)
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
            alertWithCheckButton(title: "Error Code : 2", message: "", completion: nil)
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
        
        
        Realm.asyncOpen(configuration: configuration) { [weak self] result in
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
                            let currNewUpdateDate = table.updateDate // now 06:00 AM
                            let prevUpdateDate = prevObject.updateDate
                            
                            // same day. prev update date start == newUpdateDate start.
                            // update day become nextday 06:00
                            
                            if prevUpdateDate.dayStart == currNewUpdateDate.dayStart {
                                prevObject.updateDate = currNewUpdateDate.nextDay.updateHour
                                print("same day")
                            }
                            // other day now before update day 06:00 AM. now < currNewUpdateDate
                            else if now < currNewUpdateDate {
                                prevObject.updateDate = currNewUpdateDate
                                print("other day before 06:00")
                            }
                            // other day after 06:00 AM
                            else if now >= currNewUpdateDate {
                                prevObject.updateDate = currNewUpdateDate.nextDay.updateHour
                                print("other day after 06:00")
                            }                            
                            print("Realm Upload complete")
                        }
                    })
                }
                catch {
                    print(error)
                    self?.alertWithCheckButton(title: "Error Code : 1", message: "", completion: nil)
                }
            case .failure(let error):
                print("sync realm error", error)
                self?.alertWithCheckButton(title: "Error Code : 2", message: "", completion: nil)
            }
        }
    }
    
    func loginRealm(completion: @escaping () -> Void) {
        let app = App(id: APIComponents.realmAppID)
        if let user = app.currentUser, user.isLoggedIn {
            print("Current User Exist")
            completion()
        }
        else {
            app.login(credentials: .anonymous) { result in
                switch result {
                case .success(let user):
                    print("New User", user.id)
                    completion()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

//MARK: - extension with Alamofire
extension UIViewController {
    func fetchAPIData<T: Codable>(of footBallData: FootballData, url: URL?, completion: @escaping (Result<T, APIErrorType>) -> Void) {
        guard let url = url else {
            print("url fail")
            return            
        }
        AF.request(url, method: .get, headers: footBallData.headers)
            .validate(statusCode: 200 ... 500)
            .responseDecodable(completionHandler: { [weak self] (response: DataResponse<T, AFError>) in
                switch response.result {
                case .success(_):
                    let statusCode = response.response?.statusCode ?? 500
                    switch statusCode {
                    case 429:
                        completion(.failure(.requestLimit))
                        self?.alertAPIError(statusCode: statusCode)
                    case 499:
                        completion(.failure(.timeout))
                        self?.alertAPIError(statusCode: statusCode)
                    case 500:
                        completion(.failure(.serverError))
                        self?.alertAPIError(statusCode: statusCode)
                    default:
                        guard let data = response.data,
                              let decoded = try? JSONDecoder().decode(T.self, from: data) else {
                                  print("decode fail")
                                  return }
                        completion(.success(decoded))
                        print("API CALL")
                    }
                case .failure(let error):
                    self?.alertWithCheckButton(title: "데이터를 가져오는데 실패했습니다",
                                               message: "네트워크 연결 상태를 확인해주세요.",
                                               completion: nil)
                    print(error)
                }
            })
    }
}

// MARK: - extension for activity indicator
extension UIViewController {
    func activityIndicator() -> UIActivityIndicatorView {
        let activityIndicator: UIActivityIndicatorView = {
            let activityView = UIActivityIndicatorView()
            activityView.color = .white
            activityView.style = .large
            activityView.hidesWhenStopped = true            
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
    
    func alertAPIError(statusCode : Int) {
        alertWithCheckButton(title: APIErrorType(rawValue: statusCode)?.description ?? "오류가 발생했습니다.",
                             message: "",
                             completion: nil)
    }
    
    func alertCallLimit(completion: @escaping () -> Void) {
        alertWithCheckButton(title: "더 이상 데이터를 받을 수 없습니다.",
                             message: "다음 오전 9시 이후\n다시 받을 수 있습니다.",
                             completion: completion)
    }
}
