//
//  StandingsViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/18.
//

import UIKit
import RealmSwift
import SideMenu

class StandingsViewController: BasicTabViewController<StandingsRealmData> {

    typealias standingObject = Result<StandingsTable, RealmErrorType>
    typealias standingResponses = Result<StandingAPIData, Error>
    @IBOutlet weak var standingsTableView: UITableView!
    
    override var league: League {
        didSet {
            fetchStandingRealmData()
        }
    }
    
//    //update need: season
//    override var season: Int {
//        didSet {
//            fetchStandingRealmData()
//        }
//    }
    
    override var data: [StandingsRealmData] {
        didSet {
            standingsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStandingRealmData()
    }
    
    override func viewConfig() {
        super.viewConfig()
        standingsTableView.delegate = self
        standingsTableView.dataSource = self
        standingsTableView.separatorStyle = .none
        standingsTableView.backgroundColor = .clear
        standingsTableView.layer.borderColor = UIColor.label.cgColor
    }
    
    func fetchStandingRealmData() {
        fetchRealmData(league: league) { [weak self] (result: standingObject) in
            switch result {
            case .success(let object):
                self?.data = Array(object.content)
            case .failure(let error):
                switch error {
                case .emptyData:
                    self?.fetchStandingAPIData()
                default:
                    print(error)
                    break
                }
            }
        }
    }
    
    func fetchStandingAPIData() {
        let league = URLQueryItem(name: "league", value: "\(league.leagueID)")
        let season = URLQueryItem(name: "season", value: "2021")
        let url = APIComponents.footBallRootURL.toURL(of: .standings, queryItems: [league, season])
        
        fetchAPIData(of: .standings, url: url) { [weak self] (result: standingResponses) in
            switch result {
            case .success(let standingData):
                let league = standingData.response[0].league
                
                let leagueID = league.id
                let season = league.season
                let standings = league.standings[0]
                
                let realmData = standings.map {
                    StandingsRealmData(standings: $0)
                }
                
                let list = List<StandingsRealmData>()
                realmData.forEach {
                    list.append($0)
                }
                
                let table = StandingsTable(leagueID: leagueID,
                                           season: season,
                                           standingData: list)
                
                self?.updateRealmData(table: table, leagueID: leagueID)
                self?.data = realmData
                print("API Call")
            case .failure(let error):
                print(error)
            }
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
        
        headerView.backgroundColor = .tertiarySystemGroupedBackground
        headerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        headerView.layer.cornerRadius = 30
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
