//
//  ScheduleViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/18.
//

import UIKit
import RealmSwift
import SideMenu

class ScheduleViewController: BasicTabViewController<FixturesRealmData> {
    
    typealias fixturesObject = Result<FixturesTable, RealmErrorType>
    typealias fixturesResponse = Result<FixturesData, Error>
    
    typealias ScheduleContent = [(String, String, Int?, Int?, String)]
    typealias ScheduleData = [String : ScheduleContent]
    
    @IBOutlet weak var schedulesTableView: UITableView!
    
    override var league: League {
        didSet {
            fetchFixturesRealmData()
        }
    }
    override var data: [FixturesRealmData] {
        didSet {
            makeScheduleData()
        }
    }
    
    var schedulesData: ScheduleData = [:] {
        didSet {
            dateSectionTitles = schedulesData.keys.sorted { $0 < $1 }
        }
    }
    
    var dateSectionTitles: [String] = [] {
        didSet {
            scheduleContent = dateSectionTitles.map { schedulesData[$0]! }
        }
    }
    
    var scheduleContent: [ScheduleContent] = [] {
        didSet {
            schedulesTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("schedule view did load")
        fetchFixturesRealmData()
    }
    
    override func viewConfig() {
        super.viewConfig()
        schedulesTableView.delegate = self
        schedulesTableView.dataSource = self
    }
    
    func fetchFixturesRealmData() {
        fetchRealmData(league: league) { [weak self] (result: fixturesObject) in
            switch result {
            case .success(let fixturesTable):
                self?.data = Array(fixturesTable.content)
            case .failure(let error):
                switch error {
                case .emptyData:
                    self?.fetchFixturesAPIData()
                default:
                    print(error)
                    break
                }
            }
        }
    }
    
    func fetchFixturesAPIData() {
        let leagueQuery = URLQueryItem(name: "league", value: "\(league.leagueID)")
        let seasonQuery = URLQueryItem(name: "season", value: "2021")
        let url = APIComponents.footBallRootURL.toURL(of: .fixtures, queryItems: [leagueQuery, seasonQuery])
        
        fetchAPIData(of: .fixtures, url: url) { [weak self] (result: fixturesResponse) in
            switch result {
            case .success(let fixturesData):                
                let fixturesResponse = fixturesData.response
                let fixturesData = fixturesResponse.map {
                    FixturesRealmData(fixtureResponse: $0)
                }
                
                let list = List<FixturesRealmData>()
                fixturesData.forEach {
                    list.append($0)
                }
                
                let leagueID = self!.league.leagueID
                let table = FixturesTable(leagueID: self!.league.leagueID,
                                          season: 2021,
                                          fixturesData: list)
                
                self?.updateRealmData(table: table, leagueID: leagueID)
                self?.data = Array(fixturesData[0 ..< 7])
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func makeScheduleData() {
        //filter
        
        //make dictionary
        var newScheduleData: ScheduleData = [:]
        data.sorted(by: { $0.fixtureDate < $1.fixtureDate })
            .forEach {
            let element = ($0.homeLogo, $0.awayLogo, $0.homeGoal, $0.awayGoal, $0.fixtureDate.toDate.formattedHour)
            if newScheduleData[$0.fixtureDate.toDate.formattedDay] == nil {
                newScheduleData[$0.fixtureDate.toDate.formattedDay] = [element]
            }
            else {
                newScheduleData[$0.fixtureDate.toDate.formattedDay]!.append(element)
            }
        }
        
        schedulesData = newScheduleData
    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dateSectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleContent[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "  \(dateSectionTitles[section])"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SchedulesTableViewCell.identifier,
                                                 for: indexPath) as! SchedulesTableViewCell
        cell.configure(with: scheduleContent[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
