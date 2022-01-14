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
    
    override var data: [FixturesRealmData] {
        didSet {
            if activityView.isAnimating { activityView.stopAnimating() }
            teamMenuButtonConfig()
            print("data loaded")
        }
    }
    
    
    @IBOutlet weak var teamSchedulesTableView: UITableView!
    
    
    override func viewConfig() {
        super.viewConfig()
        let cellNib = UINib(nibName: "TeamSchedulesTableViewCell", bundle: nil)
        teamSchedulesTableView.register(cellNib, forCellReuseIdentifier: TeamSchedulesTableViewCell.identifier)
        
        teamSchedulesTableView.delegate = self
        teamSchedulesTableView.dataSource = self
        teamSchedulesTableView.backgroundColor = .clear
    }
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
                                          season: 2021,
                                          fixturesData: list)
                
                self?.updateRealmData(table: table, leagueID: leagueID, season: season)
                self?.data = fixturesData
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func navAppearenceConfig() {
        super.navAppearenceConfig()
        teamMenuButtonConfig()
    }
    
    private func teamMenuButtonConfig() {
        let actions = LocalizationList.team.values.map { teamName in
            UIAction(title: "\(teamName)",
                     image: nil,
                     identifier: nil,
                     discoverabilityTitle: nil,
                     state: .mixed) { _ in
                print(teamName)
            }
        }
        let menu = UIMenu(title: "팀변경",
                          image: nil,
                          identifier: nil,
                          options: .displayInline,
                          children: actions)
        let teamMenuButton = UIBarButtonItem(title: "팀변경",
                                             image: nil,
                                             primaryAction: nil,
                                             menu: menu)
        navigationItem.rightBarButtonItem = teamMenuButton
    }
}

extension TeamSchedulesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeamSchedulesTableViewCell.identifier, for: indexPath) as! TeamSchedulesTableViewCell
        cell.testLabel.text = "\(indexPath.row)"
        cell.backgroundColor = league.colors[2]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
