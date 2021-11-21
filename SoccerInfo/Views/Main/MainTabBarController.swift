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
            let league = standingData.response[0].league
            
            let leagueID = league.id
            let season = league.season
            let standings = league.standings[0]
            
            
            standings.forEach { print($0.team.name) }
            
            let realmData = standings.map {
                StandingsRealmData(standings: $0)
            }
            
            print("============================================")
            
            let list = List<StandingsRealmData>()
            realmData.forEach {
                list.append($0)
            }
            
            let table = StandingsTable(leagueID: leagueID,
                                       season: season,
                                       standingData: list)
            
            let app = App(id: APIComponents.realmAppID)

            app.login(credentials: .anonymous) { result in
                switch result {
                case .success(let user):
                    let config = user.configuration(partitionValue: "\(leagueID)")
                    Realm.asyncOpen(configuration: config) { result in
                        switch result {
                        case .success(let realm):
                            print(realm.configuration.fileURL)
                            try! realm.write({
                                realm.add(table)
                            })
                            print(user.logOut())
                        case .failure(let error):
                            print(error)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
//            let localRealm = try! Realm()
//            print(localRealm.configuration.fileURL)
//            try! localRealm.write {
//                localRealm.add(table, update: .modified)
//            }
        }
        catch {
            print(error)
        }
    }
}
