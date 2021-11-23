//
//  StandingsViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/18.
//

import UIKit
//import Realm
import RealmSwift
import SideMenu

class StandingsViewController: BasicTabViewController<StandingsRealmData> {

    typealias standingObject = Result<StandingsTable, RealmErrorType>
    @IBOutlet weak var standingsTableView: UITableView!
    
    override var league: League {
        didSet {
            fetchStandingRealmData()
        }
    }
    override var data: [StandingsRealmData] {
        didSet {
            standingsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStandingRealmData()
    }
    
    override func viewConfig() {
        super.viewConfig()
        standingsTableView.delegate = self
        standingsTableView.dataSource = self
        standingsTableView.separatorStyle = .none
    }
    
    func fetchStandingRealmData() {
        fetchRealmData(league: league) { [weak self] (result: standingObject) in
            switch result {
            case .success(let object):                
                self?.data = Array(object.standingData)
            case .failure(let error):
                switch error {
                case .emptyData:
                    print("API call")
                default:
                    print(error)
                    break
                }
            }
        }
    }
}

extension StandingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StandingsTableViewCell.identifier,
                                                 for: indexPath) as! StandingsTableViewCell
        cell.configure(with: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let nib = Bundle.main.loadNibNamed(StandingSectionHeaderView.identifier, owner: self, options: nil)
        let headerView = nib?.first as! StandingSectionHeaderView
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension StandingsViewController: SideMenuNavigationControllerDelegate {
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        guard let sideVC = menu.topViewController as? SideViewController else { return }
        league = sideVC.selectedLeague
        print(league)
        print("side menu did disppear")
    }
}
