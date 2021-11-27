//
//  EventsViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/27.
//

import UIKit
import RealmSwift
import Kingfisher

class MatchDetailViewController: BasicTabViewController<MatchDetailRealmData> {
    deinit {
        print("MatchDetailVC Deinit")
    }
    
    enum MatchDetailSection: CaseIterable {
        case events, lineups
        
        var sectionTitle: String {
            switch self {
            case .events:
                return "기록"
            case .lineups:
                return "라인업"
            }
        }
    }
    
    enum EventsType {
        case goal, card, subst, `var`
    }

    typealias EventsResponses = Result<EventsAPIData, Error>
    typealias LineupsResponses = Result<LineupsAPIData, Error>
    typealias MatchDetailObject = Result<MatchDetailTable, RealmErrorType>
    
    var fixtureID = 0
    
    var homeLogo = ""
    var homeTeamName = ""
    
    var awayLogo = ""
    var awayTeamName = ""
    
    override var league: League {
        didSet {
            
        }
    }
    
    override var data: [MatchDetailRealmData] {
        didSet {
            guard let filtered = data.filter({ $0.fixtureID == fixtureID }).first else {
                fetchEventsAPIData()
                return
            }
            matchDetailData = filtered
        }
    }
    
    // matchDetailData not nil. optional binding when data filtering
    var matchDetailData: MatchDetailRealmData = MatchDetailRealmData.initialValue {
        didSet {
            matchDetailTableView.reloadData()
        }
    }
    
    @IBOutlet weak var matchDetailTableHeaderView: UIView!
    @IBOutlet weak var homeLogoImageView: UIImageView!
    @IBOutlet weak var awayLogoImageView: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var matchDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewConfig() {
        title = "경기정보"
        matchDetailTableView.register(UINib(nibName: EventsTableViewCell.identifier, bundle: nil),
                                      forCellReuseIdentifier: EventsTableViewCell.identifier)
        matchDetailTableView.register(UINib(nibName: LineupsTableViewCell.identifier, bundle: nil),
                                      forCellReuseIdentifier: LineupsTableViewCell.identifier)
        
        matchDetailTableView.delegate = self
        matchDetailTableView.dataSource = self
        matchDetailTableView.separatorStyle = .none
        
        homeLogoImageView.kf.setImage(with: URL(string: homeLogo))
        awayLogoImageView.kf.setImage(with: URL(string: awayLogo))
        homeTeamNameLabel.text = homeTeamName.uppercased()
        awayTeamNameLabel.text = awayTeamName.uppercased()
        fetchMatchDetailRealmData()
    }
    
    override func sideButtonConfig() {
        
    }
    
    func fetchMatchDetailRealmData() {
        fetchRealmData(league: .premierLeague) { [weak self] (result: MatchDetailObject) in
            switch result {
            case .success(let matchDetailTable):
                self?.data = Array(matchDetailTable.content)
            case .failure(let error):
                switch error {
                case .emptyData:
                    self?.fetchEventsAPIData()
                default:
                    print(error)
                    break
                }
            }
        }
    }
    
    func fetchEventsAPIData() {
        let fixtureIDQuery = URLQueryItem(name: "fixture", value: "\(fixtureID)")
        let eventsURL = APIComponents.footBallRootURL.toURL(of: .events, queryItems: [fixtureIDQuery])
        fetchAPIData(of: .events, url: eventsURL) { [weak self] (result: EventsResponses) in
            switch result {
            case .success(let eventsAPIData):
                let lineupURL = APIComponents.footBallRootURL.toURL(of: .lineups, queryItems: [fixtureIDQuery])
                self?.fetchAPIData(of: .lineups, url: lineupURL, completion: { (result: LineupsResponses) in
                    switch result {
                    case .success(let lineupsAPIData):
                        // Make Events Realm Data
                        let eventList = List<EventsRealmData>()
                        eventsAPIData.response
                            .map { EventsRealmData(eventsResponse: $0) }
                            .forEach {
                                eventList.append($0)
                            }
                        
                        // Make Lineup Realm Data
                        let homeTeam = lineupsAPIData.response[0]
                        let awayTeam = lineupsAPIData.response[1]
                        
                        let homeStartLineup = List<LineupRealmData>()
                        homeTeam.startXI
                            .map { LineupRealmData(lineupsPlayer: $0.player) }
                            .forEach { homeStartLineup.append($0) }
                        
                        let homeSubLineup = List<LineupRealmData>()
                        homeTeam.substitutes
                            .map { LineupRealmData(lineupsPlayer: $0.player) }
                            .forEach { homeSubLineup.append($0) }
                        
                        let awayStartLineup = List<LineupRealmData>()
                        awayTeam.startXI
                            .map { LineupRealmData(lineupsPlayer: $0.player) }
                            .forEach { awayStartLineup.append($0) }
                        
                        let awaySubLineup = List<LineupRealmData>()
                        awayTeam.substitutes
                            .map { LineupRealmData(lineupsPlayer: $0.player) }
                            .forEach { awaySubLineup.append($0) }
                        
                        let matchDetailRealmData = MatchDetailRealmData(fixtureID: self!.fixtureID,
                                                                        events: eventList,
                                                                        homeStartLineup: homeStartLineup,
                                                                        homeSubLineup: homeSubLineup,
                                                                        awayStartLineup: awayStartLineup,
                                                                        awaySubLineup: awaySubLineup,
                                                                        homeFormation: homeTeam.formation,
                                                                        awayFormation: awayTeam.formation)
                        
                        
                        let content = List<MatchDetailRealmData>()
                        let prevData = self!.data
                        prevData.forEach {
                            content.append($0)
                        }
                        content.append(matchDetailRealmData)
                        let table = MatchDetailTable(leagueID: self!.league.leagueID,
                                                     season: 2021,
                                                     content: content)
                        
                        self?.updateRealmData(table: table, leagueID: self!.league.leagueID, season: 2021)
                        self?.data = Array(content)
                    case .failure(let error):
                        print(error)
                    }
                })
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MatchDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return MatchDetailSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return MatchDetailSection.allCases[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? matchDetailData.events.count : matchDetailData.homeStartLineup.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EventsTableViewCell.identifier,
                                                     for: indexPath) as! EventsTableViewCell
            
            let event = matchDetailData.events[indexPath.item]
            let isHomeCell = event.teamName == homeTeamName
            cell.configure(with: event, isHomeCell: isHomeCell)
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: LineupsTableViewCell.identifier,
                                                     for: indexPath) as! LineupsTableViewCell
            
            let homeLineup = matchDetailData.homeStartLineup[indexPath.item]
            let awayLineup = matchDetailData.awayStartLineup[indexPath.item]
            cell.configure(homeLineup: homeLineup, awayLineup: awayLineup)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
