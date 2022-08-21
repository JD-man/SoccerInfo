//
//  SideViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/23.
//

import UIKit
import SnapKit

final class SideViewController: UIViewController {
    
    deinit {
        print("SideVC deinit")
    }
    
    enum SideSection: CaseIterable {
        case league
        // case cup ... update later
        
        var title: String {
            switch self {
            case .league:
                return "Leagues"
            @unknown default:
                print("SideSection title unknown default")
            }
        }
        
        var contents: [String] {
            switch self {
            case .league:
                return League.allCases.map { $0.rawValue }
            @unknown default:
                print("SideSection contents unknown default")
            }
        }
    }

    private let sideTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.register(SideTableViewCell.self,
                           forCellReuseIdentifier: SideTableViewCell.identifier)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var selectedLeague: League = .premierLeague
    let contents = SideSection.allCases.map { $0.contents }
    let sectionTitles = SideSection.allCases.map { $0.title }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        viewConfig()
    }
    
    func viewConfig() {
        sideTableView.delegate = self
        sideTableView.dataSource = self
        sideTableView.backgroundColor = .clear
        view.backgroundColor = selectedLeague.colors[0]
        
        let appearnce = UINavigationBarAppearance()
        appearnce.configureWithOpaqueBackground()
        appearnce.backgroundColor = selectedLeague.colors[0]
        
        navigationController?.navigationBar.standardAppearance = appearnce
        navigationController?.navigationBar.scrollEdgeAppearance = appearnce
    }    
}

extension SideViewController: UITableViewDelegate, UITableViewDataSource {
    // Header Config
    func numberOfSections(in tableView: UITableView) -> Int {
        return SideSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        // space for padding.. update later
        label.text = "  \(sectionTitles[section])"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .white
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    // Cell Config
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideTableViewCell.identifier,
                                                 for: indexPath) as! SideTableViewCell
        cell.backgroundColor = selectedLeague.colors[2]
        cell.leagueNameLabel.textColor = .white
        cell.leagueNameLabel.text = contents[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // navigationController of this view is SideMenuNavigationController
        let leagueName = contents[indexPath.section][indexPath.row]
        selectedLeague = League(rawValue: leagueName) ?? .premierLeague
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
