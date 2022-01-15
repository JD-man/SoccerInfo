//
//  TeamSchedulesViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2022/01/14.
//

import UIKit
import RealmSwift

class TeamSchedulesViewController: BasicTabViewController<FixturesRealmData> {
    
    typealias FixturesObject = Result<FixturesTable, RealmErrorType>
    typealias FixturesResponses = Result<FixturesAPIData, APIErrorType>
    
    @IBOutlet weak var teamSchedulesTableView: UITableView!
    
    override var data: [FixturesRealmData] {
        didSet {
            if activityView.isAnimating { activityView.stopAnimating() }
            teamMenuButtonConfig()
            filterTeamSchedules(teamID: selectedTeamID)
        }
    }
    
    private var teamSchedules: [TeamScheduleCellModel] = [] {
        didSet {
            teamSchedulesTableView.reloadData()
        }
    }
    
    private var _selectedTeamID: Int = 0 {
        didSet {
            filterTeamSchedules(teamID: selectedTeamID)
        }
    }
    private var selectedTeamID: Int {
        get {
            guard let favoriteTeamID = UserDefaults.standard.value(forKey: "favoriteTeamID") as? Int else {
                return _selectedTeamID
            }
            return favoriteTeamID
        }
        set {
            _selectedTeamID = newValue
        }
    }
    
    private var scrollSection = 0 {
        didSet {
            teamSchedulesTableView.scrollToRow(at: IndexPath(item: 0, section: scrollSection),
                                               at: .middle,
                                               animated: true)
        }
    }
    
    override func viewConfig() {
        super.viewConfig()
        let cellNib = UINib(nibName: "TeamSchedulesTableViewCell", bundle: nil)
        teamSchedulesTableView.register(cellNib, forCellReuseIdentifier: TeamSchedulesTableViewCell.identifier)
        
        teamSchedulesTableView.delegate = self
        teamSchedulesTableView.dataSource = self
        teamSchedulesTableView.backgroundColor = .clear
    }
    
    // MARK: - Fetch Data
    override func fetchData() {
        fetchRealmData(league: league, season: season) { [weak self] (result: FixturesObject) in
            switch result {
            case .success(let fixturesTable):
                self?.data = Array(fixturesTable.content)
            case .failure(let error):
                switch error {
                case .emptyData: // Realm Data is not updatedb
                    self?.fetchFixturesAPIData()
                default:
                    print(error)
                    break
                }
            }
        }
    }
    
    private func fetchFixturesAPIData() {
        fetchAPIData(of: .fixtures(season: season, league: league)) { [weak self] (result: FixturesResponses) in
            switch result {
            case .success(let fixturesData):
                guard fixturesData.results != 0 else {
                    self?.alertCallLimit() { self?.activityView.stopAnimating() }
                    return
                }
                let fixturesResponse = fixturesData.response
                let fixturesData = fixturesResponse.map {
                    FixturesRealmData(fixtureResponse: $0)
                }
                
                let list = List<FixturesRealmData>()
                fixturesData.forEach {
                    list.append($0)
                }
                
                let leagueID = self!.league.leagueID
                let season = self!.season
                let table = FixturesTable(leagueID: leagueID,
                                          season: season,
                                          fixturesData: list)
                
                self?.updateRealmData(table: table, leagueID: leagueID, season: season)
                self?.data = fixturesData
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Filter team schedules
    private func filterTeamSchedules(teamID: Int) {
        let filtered: [TeamScheduleCellModel] = data.filter {
            $0.awayID == teamID || $0.homeID == teamID
        }.sorted {
            $0.fixtureDate < $1.fixtureDate
        }.map {
            let isHomeTeam = $0.homeID == teamID
            return TeamScheduleCellModel(fixtureDate: $0.fixtureDate.toDate.formattedDate,
                                         oppsiteTeam: isHomeTeam ? LocalizationList.team[$0.awayID]! : LocalizationList.team[$0.homeID]!,
                                         homeGoal: $0.homeGoal,
                                         awayGoal: $0.awayGoal,
                                         isHomeTeam: isHomeTeam
            )
        }
        
        teamSchedules = filtered
        var section = 0
        for schedule in teamSchedules {
            if Date().formattedDate < schedule.fixtureDate {
                scrollSection = section
                break
            }
            section += 1
        }
    }
    
    
    // MARK: - Navigation config
    override func navAppearenceConfig() {
        super.navAppearenceConfig()
        teamMenuButtonConfig()
        navigationItem.title = "팀별일정"
    }
    
    private func teamMenuButtonConfig() {
        let sortedTeam = LocalizationList.team
            .sorted(by: {
                $0.value < $1.value
            })
        
        selectedTeamID = sortedTeam.first?.key ?? 47
        
        let actions = sortedTeam
            .map { teamDictioanry in
            UIAction(title: "\(teamDictioanry.value)",
                     image: nil,
                     identifier: nil,
                     discoverabilityTitle: nil,
                     state: .mixed) { [weak self] _ in
                self?.selectedTeamID = teamDictioanry.key
                self?.navigationItem.rightBarButtonItem?.title = teamDictioanry.value
            }
        }
        let menu = UIMenu(title: "팀변경",
                          image: nil,
                          identifier: nil,
                          options: .displayInline,
                          children: actions)
        let teamMenuButton = UIBarButtonItem(title: LocalizationList.team[selectedTeamID],
                                             image: nil,
                                             primaryAction: nil,
                                             menu: menu)
        navigationItem.rightBarButtonItem = teamMenuButton
        
    }
}

extension TeamSchedulesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return teamSchedules.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textColor = league.colors[1]
        label.text = section == scrollSection ? "  Round \(section + 1) ⚽️" : "  Round \(section + 1)"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeamSchedulesTableViewCell.identifier, for: indexPath) as! TeamSchedulesTableViewCell
        cell.backgroundColor = league.colors[2]
        cell.configure(with: teamSchedules[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

struct TeamScheduleCellModel {
    let fixtureDate: String
    let oppsiteTeam: String
    let homeGoal: Int?
    let awayGoal: Int?
    let isHomeTeam: Bool    
}
