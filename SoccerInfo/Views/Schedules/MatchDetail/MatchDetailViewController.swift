//
//  EventsViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/27.
//

import UIKit
import RealmSwift
import Kingfisher

class MatchDetailViewController: UIViewController {
    deinit {
        print("MatchDetailVC Deinit")
    }
    
    typealias EventsResponses = Result<EventsAPIData, Error>
    typealias LineupsResponses = Result<LineupsAPIData, Error>
    typealias MatchDetailObject = Result<MatchDetailTable, RealmErrorType>
    
    var fixtureID = 0
    
    var homeLogo = ""
    var homeTeamName = ""
    
    var awayLogo = ""
    var awayTeamName = ""
    
    var league: League = .premierLeague
    var season = 2021
    var maxSubsCount = 0
    
    var data: [MatchDetailRealmData] = [MatchDetailRealmData.initialValue] {
        didSet {
            guard let filtered = data.filter({ $0.fixtureID == fixtureID }).first else {
                fetchEventsAPIData()
                return
            }
            matchDetailData = filtered
        }
    }
    
    var matchDetailData: MatchDetailRealmData = MatchDetailRealmData.initialValue {
        didSet {
            maxSubsCount = max(matchDetailData.awaySubLineup.count,
                              matchDetailData.homeSubLineup.count)
            matchDetailTableView.reloadSections(IndexSet(0 ..< 3), with: .fade)
            if activityView.isAnimating {
                activityView.stopAnimating()
            }
        }
    }
    
    @IBOutlet weak var matchDetailTableHeaderView: UIView!
    @IBOutlet weak var homeLogoImageView: UIImageView!
    @IBOutlet weak var awayLogoImageView: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var matchDetailTableView: UITableView!
    var activityView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        fetchMatchDetailRealmData()
    }
    
    func viewConfig() {        
        title = "경기정보"
        matchDetailTableViewConfig()
        matchDetailTableHeaderView.addCorner()
        
        homeLogoImageView.kf.setImage(with: URL(string: homeLogo))
        awayLogoImageView.kf.setImage(with: URL(string: awayLogo))
        
        homeTeamNameLabel.numberOfLines = 0
        awayTeamNameLabel.numberOfLines = 0
        homeTeamNameLabel.adjustsFontSizeToFitWidth = true
        awayTeamNameLabel.adjustsFontSizeToFitWidth = true
        homeTeamNameLabel.text = homeTeamName.uppercased().modifyTeamName
        awayTeamNameLabel.text = awayTeamName.uppercased().modifyTeamName
        
        // activity view config
        activityView = activityIndicator()
        
        // header view config
        matchDetailTableHeaderView.backgroundColor = .secondarySystemGroupedBackground
    }
    
    func matchDetailTableViewConfig() {
        matchDetailTableView.delegate = self
        matchDetailTableView.dataSource = self
        matchDetailTableView.separatorStyle = .none
        
        matchDetailTableView.addShadow()
        matchDetailTableView.backgroundColor = .clear
        
        let eventsCell = UINib(nibName: EventsTableViewCell.identifier, bundle: nil)
        let lineupsCell = UINib(nibName: LineupsTableViewCell.identifier, bundle: nil)
        let formationCell = UINib(nibName: FormationTableViewCell.identifier, bundle: nil)
        matchDetailTableView.register(eventsCell, forCellReuseIdentifier: EventsTableViewCell.identifier)
        matchDetailTableView.register(lineupsCell, forCellReuseIdentifier: LineupsTableViewCell.identifier)
        matchDetailTableView.register(formationCell, forCellReuseIdentifier: FormationTableViewCell.identifier)
    }
    
    func fetchMatchDetailRealmData() {
        league = PublicPropertyManager.shared.league
        season = PublicPropertyManager.shared.season
        activityView.startAnimating()
        fetchRealmData(league: league, season: season) { [weak self] (result: MatchDetailObject) in
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
                        self?.updateRealmData(table: table, leagueID: self!.league.leagueID, season: self!.season)
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
    
    enum MatchDetailSection: CaseIterable {
        case events, formation, lineups, subs
        
        var sectionTitle: String {
            switch self {
            case .events:
                return "기록"
            case .formation:
                return "포메이션"
            case .lineups:
                return "선발 명단"
            case .subs:
                return "교체 명단"
            }
        }
    }
}

extension MatchDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return MatchDetailSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = MatchDetailSection.allCases[section].sectionTitle
        label.font = .systemFont(ofSize: 18, weight: .semibold)        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return matchDetailData.events.count
        }
        else if section == 1 {
            return 1
        }
        else if section == 2 {
            return matchDetailData.homeStartLineup.count
        }
        else {
            // prevent index error when the number of sub player is different
            return maxSubsCount
        }        
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
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: FormationTableViewCell.identifier,
                                                     for: indexPath) as! FormationTableViewCell
            
            let homeStarting = Array(matchDetailData.homeStartLineup)
            let awayStarting = Array(matchDetailData.awayStartLineup)
            cell.configure(homeLineup: homeStarting, awayLineup: awayStarting)
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: LineupsTableViewCell.identifier,
                                                     for: indexPath) as! LineupsTableViewCell
            
            let homeLineup = matchDetailData.homeStartLineup[indexPath.item]
            let awayLineup = matchDetailData.awayStartLineup[indexPath.item]
            cell.configure(homeLineup: homeLineup, awayLineup: awayLineup)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LineupsTableViewCell.identifier,
                                                     for: indexPath) as! LineupsTableViewCell
            
            // prevent index error when the number of sub player is different
            let emptyPlayer = LineupsPlayer(name: "-", number: 0, pos: "-", grid: nil)
            var homeLineup = LineupRealmData(lineupsPlayer: emptyPlayer)
            var awayLineup = LineupRealmData(lineupsPlayer: emptyPlayer)
            
            let item = indexPath.item
            if item < matchDetailData.homeSubLineup.count {
                homeLineup = matchDetailData.homeSubLineup[indexPath.item]
            }
            if item < matchDetailData.awaySubLineup.count {
                awayLineup = matchDetailData.awaySubLineup[indexPath.item]
            }
            
            cell.configure(homeLineup: homeLineup, awayLineup: awayLineup)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let item = indexPath.item
        let totalHeight: CGFloat = 270
        let minHeight: CGFloat = 55
        var height: CGFloat = 0
        if section == 0 {
            if item == 0 {
                let currTime = CGFloat(matchDetailData.events[item].time)
                height = currTime/90 * totalHeight
            }
            else {
                let currTime = matchDetailData.events[item].time
                let prevTime = matchDetailData.events[item - 1].time
                let interval = CGFloat(currTime - prevTime)
                height = interval/90 * totalHeight
            }
            return height >= minHeight ? height : minHeight
        }
        else if section == 1 {
            return 240
        }
        else {
            return 50
        }
    }
}
