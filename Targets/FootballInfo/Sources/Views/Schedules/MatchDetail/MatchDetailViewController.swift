//
//  EventsViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/27.
//

import UIKit
import RealmSwift
import SnapKit

final class MatchDetailViewController: UIViewController {
    deinit {
        print("MatchDetailVC Deinit")
    }
    
    typealias EventsResponses = Result<EventsAPIData, APIErrorType>
    typealias LineupsResponses = Result<LineupsAPIData, APIErrorType>
    typealias MatchDetailObject = Result<MatchDetailTable, RealmErrorType>
    
    var fixtureID = 0
    var homeScore = 0
    var awayScore = 0
    var homeTeamName = ""
    var awayTeamName = ""
    
    private var maxSubsCount = 0
    private var season = PublicPropertyManager.shared.season
    private var league = PublicPropertyManager.shared.league
        
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
            if activityView.isAnimating { activityView.stopAnimating() }
            maxSubsCount = max(matchDetailData.awaySubLineup.count,
                              matchDetailData.homeSubLineup.count)
            matchDetailTableView.reloadSections(IndexSet(0 ..< MatchDetailSection.allCases.count),
                                                with: .fade)            
        }
    }
    
    private let matchDetailTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorStyle = .none
        // 각 셀들을 다시 만들면서 주석처리한걸 정리하면 됨!
        tableView.register(EventsTableViewCell.self,
                           forCellReuseIdentifier: EventsTableViewCell.identifier)
        tableView.register(LineupsTableViewCell.self,
                           forCellReuseIdentifier: LineupsTableViewCell.identifier)
        tableView.register(FormationTableViewCell.self,
                           forCellReuseIdentifier: FormationTableViewCell.identifier)
        return tableView
    }()
    
    private var activityView = UIActivityIndicatorView()
    private let headerView = MatchDetailTableHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        constraintsConfig()
        fetchMatchDetailRealmData()
        headerViewConfig()
    }
    
    private func viewConfig() {
        title = "경기정보"
        gradientConfig()
        matchDetailTableViewConfig()
        activityView = activityIndicator()
    }
    
    private func gradientConfig() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [league.colors[0].cgColor, league.colors[1].cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.7)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func matchDetailTableViewConfig() {
        matchDetailTableView.delegate = self
        matchDetailTableView.dataSource = self
        matchDetailTableView.separatorStyle = .none
        matchDetailTableView.backgroundColor = .clear
        view.addSubview(matchDetailTableView)
    }
    
    private func constraintsConfig() {
        matchDetailTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        
    }
    
    private func headerViewConfig() {
        headerView.configure(homeScore: homeScore,
                             awayScore: awayScore,
                             homeTeamName: homeTeamName,
                             awayTeamName: awayTeamName)
        matchDetailTableView.tableHeaderView = headerView
    }
    
    private func fetchMatchDetailRealmData() {
        activityView.startAnimating()
        league = PublicPropertyManager.shared.league
        season = PublicPropertyManager.shared.season
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
    
    private func fetchEventsAPIData() {
        fetchAPIData(of: .events(fixtureID: fixtureID)) { [weak self] (result: EventsResponses) in
            switch result {
            case .success(let eventsAPIData):
                guard eventsAPIData.results != 0 else {
                    self?.alertCallLimit() {
                        self?.navigationController?.popViewController(animated: true)
                    }
                    return
                }
                self?.fetchAPIData(of: .lineups(fixtureID: self!.fixtureID), completion: { (result: LineupsResponses) in
                    switch result {
                    case .success(let lineupsAPIData):
                        guard lineupsAPIData.results != 0 else {
                            self?.alertCallLimit() {
                                self?.navigationController?.popViewController(animated: true)
                            }
                            return
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
                        
                        // Make Events Realm Data
                        let eventList = List<EventsRealmData>()
                        let homeStartID = homeTeam.startXI.map { $0.player.id }
                        let awayStartID = awayTeam.startXI.map { $0.player.id }
                        eventsAPIData.response
                            .map {                                
                                if $0.type == "subst" {
                                    let inID = $0.player.id ?? -1
                                    let outID = $0.assist.id ?? -2
                                    if homeStartID.contains(outID) || awayStartID.contains(outID) {
                                        return $0
                                    }
                                    else {
                                        let newPlayer = EventsPlayer(id: outID, name: $0.assist.name ?? "")
                                        let newAssist = EventsAssist(id: inID, name: $0.player.name)
                                        return EventsResponse(time: $0.time,
                                                              team: $0.team,
                                                              player: newPlayer,
                                                              assist: newAssist,
                                                              type: $0.type,
                                                              detail: $0.detail)
                                    }
                                }
                                else {
                                    return $0
                                }
                            }
                            .map {
                                EventsRealmData(eventsResponse: $0)
                            }
                            .forEach { eventList.append($0) }
                        
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
                                                     season: self!.season,
                                                     content: content)
                        self?.updateRealmData(table: table,
                                              leagueID: self!.league.leagueID,
                                              season: self!.season)
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
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = MatchDetailSection.allCases[section].sectionTitle        
        return label
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let footerView = FormationSectionFooterView()
            footerView.configure(with: matchDetailData)
            return footerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 1 ? 50 : CGFloat.leastNonzeroMagnitude
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
        else if indexPath.section == 1 {
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
            
            cell.backgroundColor = league.colors[2]
            cell.configure(homeLineup: homeLineup, awayLineup: awayLineup)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LineupsTableViewCell.identifier,
                                                     for: indexPath) as! LineupsTableViewCell
            
            // prevent index error when the number of sub player is different
            let emptyPlayer = LineupsPlayer(id: -1, name: "-", number: 0, pos: "-", grid: nil)
            var homeLineup = LineupRealmData(lineupsPlayer: emptyPlayer)
            var awayLineup = LineupRealmData(lineupsPlayer: emptyPlayer)
            
            let item = indexPath.item
            if item < matchDetailData.homeSubLineup.count {
                homeLineup = matchDetailData.homeSubLineup[indexPath.item]
            }
            if item < matchDetailData.awaySubLineup.count {
                awayLineup = matchDetailData.awaySubLineup[indexPath.item]
            }
            
            cell.backgroundColor = league.colors[2]
            cell.configure(homeLineup: homeLineup, awayLineup: awayLineup)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = indexPath.item
        let section = indexPath.section
        
        if section == 0 {
            
            var height: CGFloat = 0
            let minHeight: CGFloat = 55
            let totalHeight: CGFloat = 270
            
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
