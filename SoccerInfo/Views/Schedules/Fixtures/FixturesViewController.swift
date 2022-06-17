//
//  ScheduleViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/18.
//

import UIKit
import RealmSwift
import SideMenu

final class FixturesViewController: BasicTabViewController<FixturesRealmData> {
    // Fixtures RealmData
    typealias FixturesObject = Result<FixturesTable, RealmErrorType>
    // API Response
    typealias FixturesResponses = Result<FixturesAPIData, APIErrorType>
    
    // Array of FixturesContent
    typealias FixturesContents = [FixturesContent]
    
    // Dictionary of match date(section title) : schedule content
    typealias FixturesDatas = [String : FixturesContents]
    
    private let schedulesTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(FixturesTableViewCell.self,
                           forCellReuseIdentifier: FixturesTableViewCell.identifier)
        return tableView
    }()
    
    /*
     Change league : fetchData
     when Set data or Change first day by swipe : make scheduleData of data
     when Set ScheduleData : make dateSectionTitles
     when Set dateSectionTitles: make schedule content
     when Set scheduleContent : Reload TableView
     */
    
    override var data: [FixturesRealmData] {
        didSet {            
            let matchDates = data.map { return $0.fixtureDate.toDate.formattedDay }
            openingMatchDate = matchDates.min() ?? ""
            lastMatchDate = matchDates.max() ?? ""
            makeScheduleData()
        }
    }
    
    private var schedulesData: FixturesDatas = [:] {
        didSet {
            dateSectionTitles = schedulesData.keys.sorted { $0 < $1 }
        }
    }
    private var dateSectionTitles = [String](repeating: "날짜", count: 7) {
        didSet {
            scheduleContent = dateSectionTitles.map { schedulesData[$0]! }
        }
    }
    private var scheduleContent = [FixturesContents](repeating: [FixturesContent.initialContent], count: 7) {
        didSet {            
            if activityView.isAnimating { activityView.stopAnimating() }
            schedulesTableView.reloadSections(IndexSet(0 ..< 7), with: .fade)
            //schedulesTableView.reloadData()
        }
    }
    
    var firstDay: Date = Date().fixtureFirstDay {
        didSet {
            // gesture work when self is visible only.
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let tab = windowScene.windows.first?.rootViewController as? MainTabBarController,
                  let nav = tab.selectedViewController as? UINavigationController,
                  nav.visibleViewController == self else { return }
            makeScheduleData()
        }
    }
    
    private var lastMatchDate: String = ""
    private var openingMatchDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
    }
    
    override func viewConfig() {
        super.viewConfig()
        // Schedules TableView Config        
        schedulesTableView.delegate = self
        schedulesTableView.dataSource = self
        schedulesTableView.backgroundColor = .clear
        schedulesTableView.separatorInset.right = schedulesTableView.separatorInset.left
        
        // Swipe Gesture for change monday of week
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self,
                                                        action: #selector(swipeAction(swipeGesture:)))
        leftSwipeGesture.direction = .left
        view.addGestureRecognizer(leftSwipeGesture)

        let rightSwipeGesture = UISwipeGestureRecognizer(target: self,
                                                         action: #selector(swipeAction(swipeGesture:)))
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(rightSwipeGesture)
    }
    
    override func navAppearenceConfig() {
        super.navAppearenceConfig()
        let manualButton = UIBarButtonItem(barButtonSystemItem: .bookmarks,
                                           target: self,
                                           action: #selector(manualButtonClicked))
        manualButton.tintColor = .link
        navigationItem.rightBarButtonItem = manualButton
    }
    
    @objc private func manualButtonClicked() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "사용법",
                                            style: .default,
                                            handler: { [weak self] _ in
            let manualVC = ManualViewController()
            self?.present(manualVC, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "오픈소스 라이센스",
                                            style: .default,
                                            handler: { [weak self] _ in
            let openSourceVC = OpenSourceLicenseViewController()
            self?.present(openSourceVC, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "취소",
                                            style: .destructive,
                                            handler: nil))
        present(actionSheet, animated: true, completion: nil)
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
                                          season: season,
                                          fixturesData: list)
                
                self?.updateRealmData(table: table, leagueID: leagueID, season: season)
                self?.data = fixturesData
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func makeScheduleData() {
        
        //make dictionary
        var newScheduleData: FixturesDatas = [:]
        for after in 0 ..< 7 {
            let formattedDay = Calendar.CalendarKST.date(byAdding: .day, value: after, to: firstDay)!.formattedDay
            
            newScheduleData[formattedDay] = []
        }
        // filter week -> sort by date -> make dictionary
        data.filter { $0.fixtureDate.toDate >= firstDay && $0.fixtureDate.toDate < firstDay.afterWeekDay}
            .sorted(by: { $0.fixtureDate < $1.fixtureDate })
            .forEach {
                let element = FixturesContent(homeID: $0.homeID,
                                              homeName: $0.homeName,
                                              homeLogo: $0.homeLogo,
                                              homeGoal: $0.homeGoal,
                                              awayID: $0.awayID,
                                              awayName: $0.awayName,
                                              awayLogo: $0.awayLogo,
                                              awayGoal: $0.awayGoal,
                                              matchHour: $0.fixtureDate.toDate.formattedHour,
                                              fixtureID: $0.fixtureID)
                if newScheduleData[$0.fixtureDate.toDate.formattedDay] == nil {
                    newScheduleData[$0.fixtureDate.toDate.formattedDay] = [element]
                }
                else {
                    newScheduleData[$0.fixtureDate.toDate.formattedDay]!.append(element)
                }
            }
        if newScheduleData.count == 7 {
            schedulesData = newScheduleData
        }
        else {
            alertWithCheckButton(title: "1주일 정보 로딩 실패",
                                 message: "\(newScheduleData.keys)",
                                 completion: nil)
        }
    }
    
    @objc private func swipeAction(swipeGesture: UISwipeGestureRecognizer) {
        // check opening or last match day info is included
        
        switch swipeGesture.direction {
        case .left:
            guard dateSectionTitles.contains(lastMatchDate) == false else {
                alertWithCheckButton(title: "마지막 일정입니다.", message: "더 이상 경기가 없습니다.", completion: nil)
                return
            }
            firstDay = firstDay.afterWeekDay
        case .right:
            guard dateSectionTitles.contains(openingMatchDate) == false else {
                alertWithCheckButton(title: "첫번째 일정입니다.", message: "더 이상 경기가 없습니다.", completion: nil)
                return
            }
            firstDay = firstDay.beforeWeekDay
        default:
            print("default")
            break
        }
    }
}

extension FixturesViewController: UITableViewDelegate, UITableViewDataSource {
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
        label.textColor = .white
        if dateSectionTitles[section].sectionTitleToDate.dayStart == Date().dayStart {
            label.text?.append(" ⚽️")
        }
        label.font = .systemFont(ofSize: 20, weight: .semibold)        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FixturesTableViewCell.identifier,
                                                 for: indexPath) as! FixturesTableViewCell
        
        let item = indexPath.item
        let section = indexPath.section
        let sectionCount = scheduleContent[section].count
        
        cell.backgroundColor = league.colors[2]
        cell.noMatchCellLabel.backgroundColor = league.colors[2]
        cell.noMatchCellLabel.isHidden = sectionCount > 0        
        if sectionCount > 0 {
            cell.configure(with: scheduleContent[section][item])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContent = scheduleContent[indexPath.section][indexPath.item]
        
        // when match was over, push match detail VC
        if let _ = selectedContent.homeGoal {
            let storyboard = UIStoryboard(name: "MatchDetail", bundle: nil)
            let matchDetailVC = storyboard.instantiateViewController(withIdentifier: "MatchDetailViewController") as! MatchDetailViewController            
            matchDetailVC.fixtureID = selectedContent.fixtureID            
            matchDetailVC.homeScore = selectedContent.homeGoal ?? 0
            matchDetailVC.awayScore = selectedContent.awayGoal ?? 0
            matchDetailVC.homeTeamName = selectedContent.homeName
            matchDetailVC.awayTeamName = selectedContent.awayName
            navigationController?.pushViewController(matchDetailVC, animated: true)            
        }
        // when match is not started, notification add request
        else {
            let sectionDate = dateSectionTitles[indexPath.section]
            let matchHour = selectedContent.matchHour.components(separatedBy: ":").map { Double($0) ?? 0}
            let matchDate = Date(timeInterval: 3600 * matchHour[0] + 60 * matchHour[1],
                                 since: sectionDate.sectionTitleToDate)
            if Date() >= matchDate {
                alertWithCheckButton(title: "이미 시작됐거나 지연된 경기입니다.", message: "", completion: nil)
                return
            }
                
            let notiManager = UserNotificationCenterManager()
            notiManager.setNotification(content: selectedContent,
                                        sectionDate: sectionDate) { [weak self] notiResult in
                DispatchQueue.main.async {
                    switch notiResult {
                    case .added, .removed:
                        self?.alertWithCheckButton(title: "경기 알림 예약이 \(notiResult.rawValue)됐습니다.",
                                                   message: "\(selectedContent.homeName) vs \(selectedContent.awayName)",
                                                   completion: {
                            self?.schedulesTableView.reloadRows(at: [indexPath], with: .fade)
                        })
                    case .denied:
                        self?.alertWithSettingURL(title: "알림이 설정되지 않았습니다.",
                                                  message: "알림 설정을 해주셔야 경기 시간 알림 사용이 가능합니다.",
                                                  completion: nil)
                    }
                }                
            }
        }
    }
}
