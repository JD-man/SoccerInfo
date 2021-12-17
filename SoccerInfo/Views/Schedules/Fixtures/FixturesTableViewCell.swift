//
//  SchedulesTableViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/24.
//

import UIKit
import Kingfisher

class FixturesTableViewCell: UITableViewCell {
    static let identifier = "FixturesTableViewCell"
    
    @IBOutlet weak var homeNameLabel: UILabel!
    @IBOutlet weak var awayNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var noMatchCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewConfig()
    }
    
    func viewConfig() {
        timeLabel.isHidden = true
        scoreLabel.isHidden = true                
        isUserInteractionEnabled = false
        backgroundColor = .secondarySystemGroupedBackground
        
        timeLabel.textColor = .systemGray
        timeLabel.font = .systemFont(ofSize: 12, weight: .medium)
        scoreLabel.font = .systemFont(ofSize: 13, weight: .medium)
        
        homeNameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        awayNameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        homeNameLabel.textAlignment = .right
        awayNameLabel.textAlignment = .left
    }
    
    func configure(with data: FixturesContent) {
        homeNameLabel.text = LocalizationList.team[data.homeID] ?? ""
        awayNameLabel.text = LocalizationList.team[data.awayID] ?? ""
        if let homeGoal = data.homeGoal, let awayGoal = data.awayGoal {
            timeLabel.isHidden = true
            scoreLabel.isHidden = false
            isUserInteractionEnabled = true
            accessoryType = .disclosureIndicator
            scoreLabel.text = "\(homeGoal) - \(awayGoal)"
            if UserDefaults.standard.value(forKey: "\(data.fixtureID)") != nil {
                UserDefaults.standard.removeObject(forKey: "\(data.fixtureID)")
            }
        }
        else {
            accessoryType = .checkmark
            scoreLabel.isHidden = true
            timeLabel.isHidden = false
            isUserInteractionEnabled = true
            timeLabel.text = "\(data.matchHour)"
            
            // set accessory color by UserDefaults reserved fixture array
            if let reserveds = UserDefaults.standard.value(forKey: "ReservedFixtures") as? [Int] {
                tintColor = reserveds.contains(data.fixtureID) ? .link : .gray
            }
            else {
                tintColor = .gray
            }
        }        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tintColor = .gray
        timeLabel.text = nil
        scoreLabel.text = nil
        accessoryType = .none
        homeNameLabel.text = nil
        awayNameLabel.text = nil
        isUserInteractionEnabled = false
    }
}
