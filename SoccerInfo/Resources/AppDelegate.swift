//
//  AppDelegate.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/15.
//

import UIKit
import RealmSwift

// 첫뷰시작전에 로그인, 노티 체크 -> 여기서 해줘야됨
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableView.appearance().showsHorizontalScrollIndicator = false
        UIBarButtonItem.appearance().tintColor = .label
        UITableViewCell.appearance().selectionStyle = .none
        
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        group.enter()
        print("login start")
        queue.async {
            let app = App(id: APIComponents.realmAppID)
            if let currentUser = app.currentUser, currentUser.isLoggedIn == true {
                print("current user exist",currentUser.id)
                sleep(1)
                group.leave()
                return
            }
            else {
                app.login(credentials: .anonymous) { result in
                    switch result {
                    case .success(let user):
                        print("new anonymous", user.id)
                        group.leave()
                    case .failure(let error):
                        print(error)
                        group.leave()
                    }
                }
            }
        }
        group.enter()
        queue.async {
            print("noti check")
            let notiCenter = UserNotificationCenterManager()
            notiCenter.userNotificationCenter.getNotificationSettings {
                switch $0.authorizationStatus {
                case .denied:
                    if let reserved = UserDefaults.standard.object(forKey: "ReservedFixtures") as? [Int] {
                        for fixture in reserved {
                            print(fixture)
                            notiCenter.userNotificationCenter.removePendingNotificationRequests(withIdentifiers: ["\(fixture)"])
                            print("removing")
                        }
                        UserDefaults.standard.removeObject(forKey: "ReservedFixtures")
                    }
                    print("noti check complete")
                    group.leave()
                default:
                    group.leave()
                }
            }
        }
        
        group.wait()
        print("AppDelegate end")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

