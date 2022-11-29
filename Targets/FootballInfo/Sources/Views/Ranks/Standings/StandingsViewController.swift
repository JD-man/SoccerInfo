////
////  StandingsViewController.swift
////  SoccerInfo
////
////  Created by JD_MacMini on 2021/11/18.
////
//
//import UIKit
//import RealmSwift
//import SideMenu
//
//final class StandingsViewController: BasicTabViewController<StandingsRealmData> {
//
//    typealias standingObject = Result<StandingsTable, RealmErrorType>
//    typealias standingResponses = Result<StandingAPIData, APIErrorType>
//    
//    private let standingsTableView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.separatorStyle = .none
//        tableView.register(StandingsTableViewCell.self,
//                           forCellReuseIdentifier: StandingsTableViewCell.identifier)
//        return tableView
//    }()
//    
//    override var data: [StandingsRealmData] {
//        didSet {
//            if activityView.isAnimating { activityView.stopAnimating() }            
//            standingsTableView.reloadData()
//        }
//    }
//    
//    override func viewConfig() {
//        super.viewConfig()
//        standingsTableView.delegate = self
//        standingsTableView.dataSource = self
//        standingsTableView.separatorStyle = .none
//        standingsTableView.backgroundColor = .clear
//        standingsTableView.layer.borderColor = UIColor.label.cgColor
//        addSubviews(standingsTableView)
//        
//        view.backgroundColor = .secondarySystemGroupedBackground
//    }
//    
//    override func constraintsConfig() {
//        super.constraintsConfig()
//        standingsTableView.snp.makeConstraints { make in
//            make.edges.equalTo(view.safeAreaLayoutGuide)
//        }
//    }
//    
//    override func fetchData() {        
//        fetchRealmData(league: league, season: season) { [weak self] (result: standingObject) in
//            switch result {
//            case .success(let object):
//                self?.data = Array(object.content)
//            case .failure(let error):
//                switch error {
//                case .emptyData:
//                    self?.fetchStandingAPIData()
//                default:
//                    print(error)
//                    break
//                }
//            }
//        }
//    }
//    
//    
//    private func fetchStandingAPIData() {
//        fetchAPIData(of: .standings(season: season, league: league)) { [weak self] (result: standingResponses) in
//            switch result {
//            case .success(let standingData):
//                guard standingData.results != 0 else {
//                    self?.alertCallLimit() { self?.activityView.stopAnimating() }
//                    return
//                }
//                
//                let league = standingData.response[0].league
//                let leagueID = league.id
//                let season = league.season
//                let standings = league.standings[0]
//                
//                let realmData = standings.map {
//                    StandingsRealmData(standings: $0)
//                }
//                
//                let list = List<StandingsRealmData>()
//                realmData.forEach {
//                    list.append($0)
//                }
//                
//                let table = StandingsTable(leagueID: leagueID,
//                                           season: season,
//                                           standingData: list)
//                
//                self?.updateRealmData(table: table, leagueID: leagueID, season: season)
//                self?.data = realmData                
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//}
//
//extension StandingsViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: StandingsTableViewCell.identifier,
//                                                 for: indexPath) as! StandingsTableViewCell
//        cell.configure(with: data[indexPath.row])
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {        
//        return StandingSectionHeaderView()
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let squadVC = SquadsViewController()
//        let selectedData = data[indexPath.row]
//        
//        squadVC.id = selectedData.teamID
//        squadVC.currentRank = selectedData.rank
//        squadVC.teamName = selectedData.teamName
//        
//        let navSquadVC = UINavigationController(rootViewController: squadVC)
//        present(navSquadVC, animated: true, completion: nil)
//    }
//}
