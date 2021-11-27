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
    
    var data: [MatchDetailRealmData] = [] {
        didSet {
            print(data)
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
        viewConfig()
    }
    
    func viewConfig() {
        title = "경기정보"
        matchDetailTableView.register(UINib(nibName: EventsTableViewCell.identifier, bundle: nil),
                                      forCellReuseIdentifier: EventsTableViewCell.identifier)
        matchDetailTableView.register(UINib(nibName: LineupsTableViewCell.identifier, bundle: nil),
                                      forCellReuseIdentifier: LineupsTableViewCell.identifier)
        
        matchDetailTableView.delegate = self
        matchDetailTableView.dataSource = self
        
        homeLogoImageView.kf.setImage(with: URL(string: homeLogo))
        awayLogoImageView.kf.setImage(with: URL(string: awayLogo))
        homeTeamNameLabel.text = homeTeamName.uppercased()
        awayTeamNameLabel.text = awayTeamName.uppercased()
        //fetchEventsAPIData()
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
                print(eventsAPIData.response)
                print("======================================")
                
                let lineupURL = APIComponents.footBallRootURL.toURL(of: .lineups, queryItems: [fixtureIDQuery])
                self?.fetchAPIData(of: .lineups, url: lineupURL, completion: { (result: LineupsResponses) in
                    switch result {
                    case .success(let lineupsAPIData):
                        print(lineupsAPIData.response)
                        
                        let eventList = List<EventsRealmData>()
//                        eventsAPIData.response.forEach {
//                            
//                        }
                        
                        
                        
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EventsTableViewCell.identifier,
                                                     for: indexPath) as! EventsTableViewCell            
            cell.awayPlayerNameLabel.text = "awayPlayer"
            cell.homePlayerNameLabel.text = "homePlayer"
            cell.homeEventTypeImageView.image = UIImage.init(systemName: "lanyardcard.fill")
            cell.awayEventTypeImageView.image = UIImage.init(systemName: "lanyardcard.fill")
            cell.timeLabel.text = "88"
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: LineupsTableViewCell.identifier,
                                                     for: indexPath) as! LineupsTableViewCell
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
