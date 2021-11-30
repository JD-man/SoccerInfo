//
//  UserNotificationCenterManager.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/30.
//

import UIKit

struct UserNotificationCenterManager {
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    func setNotification(content: FixturesContent, sectionDate: String, completion: @escaping () -> Void) {
        userNotificationCenter.getPendingNotificationRequests {
            let fixtureID = content.fixtureID
            let pendingFixture = $0.filter { $0.identifier == "\(fixtureID)" }
            print("Prev : ", pendingFixture)
            if pendingFixture.isEmpty {
                // add noti
                addRequest(content: content, sectionDate: sectionDate)
                UserDefaults.standard.set(true, forKey: "\(fixtureID)")
                completion()
            }
            else {
                // remove noti
                userNotificationCenter.removePendingNotificationRequests(withIdentifiers: ["\(fixtureID)"])
                UserDefaults.standard.removeObject(forKey: "\(fixtureID)")
                completion()
            }
        }
    }
    
    private func addRequest(content: FixturesContent, sectionDate: String) {
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
                                                      date: component, // 여기에 정확한 시간이 들어가야함
                                                      identifier: "\(content.fixtureID)")
                userNotificationCenter.add(request) { error in
                    if let error = error {
                        print("Notification Error: ", error)
                    }
                }
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
