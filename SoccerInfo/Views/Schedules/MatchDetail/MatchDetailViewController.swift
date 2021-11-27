//
//  EventsViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/27.
//

import UIKit

class MatchDetailViewController: UIViewController {
    
    var fixtureID = 0

    @IBOutlet weak var fixtureIDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fixtureIDLabel.text = "\(fixtureID)"
    }
    
    // MatchDetailRealmData -> id... List<EventData> List<LineupData>
}
