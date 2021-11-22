//
//  StandingsViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/18.
//

import UIKit
import RealmSwift

class StandingsViewController: UIViewController {

    @IBOutlet weak var standingsTableView: UITableView!
    
    var data: [StandingsRealmData] = [] {
        didSet {
            standingsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        viewConfig()
        fetchData()
    }
    
    func viewConfig() {
        standingsTableView.delegate = self
        standingsTableView.dataSource = self
        standingsTableView.separatorStyle = .none
    }
    
    func fetchData() {
        guard let filePath = Bundle.main.path(forResource: "Standing", ofType: "json"),
              let jsonString = try? String(contentsOfFile: filePath) else {
                  return
              }

        do {
//            // fetch from Football - API
//            let standingData = try JSONDecoder().decode(StandingData.self, from: jsonString.data(using: .utf8)!)
//            let league = standingData.response[0].league
//
//            let leagueID = league.id
//            let season = league.season
//            let standings = league.standings[0]
//
//            let realmData = standings.map {
//                StandingsRealmData(standings: $0)
//            }
//
//            data = realmData

            print("============================================")
            
            let app = App(id: APIComponents.realmAppID)
//            app.login(credentials: .anonymous) { result in
//                switch result {
//                case .success(let user):
//                    print(user.id)
//                case .failure(let error):
//                    print(error)
//                }
//            }
            
            // fetch from Local Realm
            let user = app.currentUser!
            let config = user.configuration(partitionValue: "\(39)")
            
            let localRealm = try! Realm(configuration: config)
            let realmData = try! localRealm.objects(StandingsTable.self).first!
            data = Array(realmData.standingData)
            
            
            // fetch from Cloud Realm

//            let list = List<StandingsRealmData>()
//            realmData.forEach {
//                list.append($0)
//            }
//
//            let table = StandingsTable(leagueID: leagueID,
//                                       season: season,
//                                       standingData: list)



//            app.login(credentials: .anonymous) { [weak self] result in
//                switch result {
//                case .success(let user):
//                    let config = user.configuration(partitionValue: "\(39)")
//                    Realm.asyncOpen(configuration: config) { result in
//                        switch result {
//                        case .success(let realm):
//                            let standingData = try! realm.objects(StandingsTable.self).first!
//                            self?.data = Array(standingData.standingData)
//                            print(realm.configuration.fileURL)
////                            try! realm.write({
////                                realm.add(table)
////                            })
//                        case .failure(let error):
//                            print(error)
//                        }
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            }
        }
        catch {
            print(error)
        }
    }
}

extension StandingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StandingsTableViewCell.identifier,
                                                 for: indexPath) as! StandingsTableViewCell
        cell.configure(with: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let nib = Bundle.main.loadNibNamed(StandingSectionHeaderView.identifier, owner: self, options: nil)
        let headerView = nib?.first as! StandingSectionHeaderView
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
