//
//  MainTabBarController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/18.
//

import UIKit
import RealmSwift

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        // Do any additional setup after loading the view.
        
    }
    
    func viewConfig() {
        tabBar.tintColor = .label
        tabBar.backgroundColor = .systemBackground
    }
    
    func fetchData() {
        guard let filePath = Bundle.main.path(forResource: "Standing", ofType: "json"),
              let jsonString = try? String(contentsOfFile: filePath) else {
                  return
              }
              
        do {
            let standingData = try JSONDecoder().decode(StandingData.self, from: jsonString.data(using: .utf8)!)
            let standings = standingData.response[0].league.standings[0]
            
            standings.forEach { print($0.team.name) }
            
            let realmData = standings.map {
                StandingsRealmData(standings: $0)
            }
            
            print("============================================")
            
            let list = List<StandingsRealmData>()
            realmData.forEach {
                list.append($0)
            }
            
            let table = StandingsTable(data: list)
            let localRealm = try! Realm()            
            try! localRealm.write {
                localRealm.add(table, update: .modified)
            }            
        }
        catch {
            print(error)
        }
    }
}
