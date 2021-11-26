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
    
    // Fixtures RealmData
    typealias fixturesObject = Result<FixturesTable, RealmErrorType>
    // API Response
    typealias fixturesResponse = Result<FixturesData, Error>
    
    // Dictionary of match date(section title) : schedule content
    typealias ScheduleData = [String : ScheduleContent]
    
    // Schedule content Tuple: (homeLogo, awayLogo, homeGoal, awayGoal, match hour)
    typealias ScheduleContent = [(String, String, Int?, Int?, String)]
    
    
    @IBOutlet weak var schedulesTableView: UITableView!
    @IBOutlet weak var noMatchLabel: UILabel!
    
    /*
     Change league : fetchData
     Set data or Change monday by swipe : make scheduleData of data
     Set ScheduleData : make dateSectionTitles
     Set dateSectionTitles: make schedule content
     Set scheduleContent : Reload TableView
     */
    
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
    var firstDay: Date = Date().saturdayOfThisWeek {
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
            noMatchLabel.isHidden = scheduleContent.count > 0
            
            // prevent delete section error when first view load
            if scheduleContent.count > 0 {
                schedulesTableView.reloadSections(IndexSet(0 ..< 7), with: .fade)
            }
            else {
                schedulesTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFixturesRealmData()
    }
    
    override func viewConfig() {
        super.viewConfig()
        schedulesTableView.delegate = self
        schedulesTableView.dataSource = self
        schedulesTableView.separatorInset.right = schedulesTableView.separatorInset.left
        
        // Swipe Gesture for change monday of week
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipeGesture:)))
        leftSwipeGesture.direction = .left
        view.addGestureRecognizer(leftSwipeGesture)
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipeGesture:)))
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(rightSwipeGesture)
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
                self?.data = fixturesData
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func makeScheduleData() {
        
        //make dictionary
        var newScheduleData: ScheduleData = [:]
        for after in 0 ..< 7 {
            let formattedDay = Calendar.current.date(byAdding: .day, value: after, to: firstDay)!.formattedDay
            newScheduleData[formattedDay] = []
        }
        
        // filter week -> sort by date -> make dictionary
        data.filter { $0.fixtureDate.toDate >= firstDay && $0.fixtureDate.toDate < firstDay.afterWeekDay}
            .sorted(by: { $0.fixtureDate < $1.fixtureDate })
            .forEach {
                let element = ($0.homeLogo,
                               $0.awayLogo,
                               $0.homeGoal,
                               $0.awayGoal,
                               $0.fixtureDate.toDate.formattedHour)
                if newScheduleData[$0.fixtureDate.toDate.formattedDay] == nil {
                    newScheduleData[$0.fixtureDate.toDate.formattedDay] = [element]
                }
                else {
                    newScheduleData[$0.fixtureDate.toDate.formattedDay]!.append(element)
                }
            }
        schedulesData = newScheduleData
    }
    
    @objc func swipeAction(swipeGesture: UISwipeGestureRecognizer) {
        switch swipeGesture.direction {
        case .left:
            firstDay = firstDay.afterWeekDay
        case .right:
            firstDay = firstDay.beforeWeekDay
        default:
            print("default")
            break
        }
    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dateSectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contentCount = scheduleContent[section].count
        return contentCount == 0 ? 1 : contentCount
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
        let sectionCount = scheduleContent[indexPath.section].count
        cell.noMatchCellLabel.isHidden = sectionCount > 0
        if sectionCount > 0 {
            cell.configure(with: scheduleContent[indexPath.section][indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
