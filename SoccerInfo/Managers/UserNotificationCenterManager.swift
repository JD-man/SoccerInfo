//
//  UserNotificationCenterManager.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/30.
//

import UIKit
import UserNotifications

struct UserNotificationCenterManager {
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    // Notification allowed : completion(true)
    func setNotification(content: FixturesContent, sectionDate: String, completion: @escaping (Bool) -> Void) {
        // 1. Check Notification allowed
        userNotificationCenter.getNotificationSettings {
            switch $0.authorizationStatus {
            // 2-1. Disallowed: remove all request, reserved fixtures, alert -> end
            case .denied, .notDetermined:
                userNotificationCenter.removeAllPendingNotificationRequests()
                UserDefaults.standard.removeObject(forKey: "ReservedFixtures")
                completion(false)
            // 2-2. allowed: add request process
            default:
                // 3. Check fixture already added
                let fixtureID = content.fixtureID
                if let reserved = UserDefaults.standard.object(forKey: "ReservedFixtures") as? [Int] {
                    // 3-1. fixture is already added -> remove noti -> end
                    if reserved.contains(fixtureID) {
                        print("remove noti")
                        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: ["\(fixtureID)"])
                        if var reserveds = UserDefaults.standard.value(forKey: "ReservedFixtures") as? [Int],
                           let reservedIndex = reserveds.firstIndex(of: fixtureID) {
                            reserveds.remove(at: reservedIndex)
                            UserDefaults.standard.set(reserveds, forKey: "ReservedFixtures")
                        }
                        completion(true)
                    }
                    // 3-2. fixture is not added
                    else {
                        addRequest(content: content, sectionDate: sectionDate, completion: completion)
                    }
                }
                // 3-3. user allowed but no reserved
                else {
                    addRequest(content: content, sectionDate: sectionDate, completion: completion)
                }
            }
        }
    }
    
    private func addRequest(content: FixturesContent, sectionDate: String, completion: @escaping (Bool) -> Void) {
        // if save with notification switch on status
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .sound, .badge)
        userNotificationCenter.requestAuthorization(options: authOptions) { isNotificationUsed, error in
            // if user allow authorization request
            if isNotificationUsed {
                let date = sectionDate.sectionTitleToDate
                var component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                let hourComponent = content.matchHour.components(separatedBy: ":")
                component.hour = Int(hourComponent[0])! - 1
                component.minute = Int(hourComponent[1])!
                let request = makeNotificationRequest(title: "1시간 후 경기 시작합니다!!",
                                                      body: "\(content.homeName) VS \(content.awayName) ",
                                                      date: component,
                                                      identifier: "\(content.fixtureID)")
                userNotificationCenter.add(request) { error in
                    if let error = error {
                        print("Notification Error: ", error)
                    }
                    else {
                        // when addition complete
                        print("addition complete")
                        if var reserveds = UserDefaults.standard.value(forKey: "ReservedFixtures") as? [Int] {
                            reserveds.append(content.fixtureID)
                            UserDefaults.standard.set(reserveds, forKey: "ReservedFixtures")
                        }
                        else {
                            UserDefaults.standard.set([content.fixtureID], forKey: "ReservedFixtures")
                        }
                        completion(true)
                    }
                }
            }
            // when noti disallowed
            else {
                userNotificationCenter.removeAllPendingNotificationRequests()                
                UserDefaults.standard.removeObject(forKey: "ReservedFixtures")
                completion(false)
                print("not allowed")
            }
        }
    }
    
    private func makeNotificationRequest(title: String, body: String, date: DateComponents, identifier: String) -> UNNotificationRequest {
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = title
        notificationContent.body = body
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        let request = UNNotificationRequest(identifier: identifier,
                                            content: notificationContent,
                                            trigger: trigger)
        return request
    }
}
