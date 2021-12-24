//
//  SchedulesTableViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/24.
//

import UIKit


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
        
        timeLabel.textColor = .systemGray
        timeLabel.font = .systemFont(ofSize: 12, weight: .medium)
        scoreLabel.font = .systemFont(ofSize: 13, weight: .medium)
        
        scoreLabel.textColor = .white
        homeNameLabel.textColor = .white
        awayNameLabel.textColor = .white
        
        homeNameLabel.textAlignment = .right
        awayNameLabel.textAlignment = .left
        
        homeNameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        awayNameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    
    func configure(with data: FixturesContent) {
        homeNameLabel.text = LocalizationList.team[data.homeID] ?? ""
        awayNameLabel.text = LocalizationList.team[data.awayID] ?? ""
        if let homeGoal = data.homeGoal, let awayGoal = data.awayGoal {
            timeLabel.isHidden = true
            scoreLabel.isHidden = false
            isUserInteractionEnabled = true
            scoreLabel.text = "\(homeGoal) - \(awayGoal)"
            
            tintColor = .gray
            accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
            if UserDefaults.standard.value(forKey: "\(data.fixtureID)") != nil {
                UserDefaults.standard.removeObject(forKey: "\(data.fixtureID)")
            }
        }        
        else {            
            scoreLabel.isHidden = true
            timeLabel.isHidden = false
            isUserInteractionEnabled = true
            timeLabel.text = "\(data.matchHour)"
            
            accessoryView = UIImageView(image: UIImage(systemName: "checkmark"))
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
        accessoryView = nil
        homeNameLabel.text = nil
        awayNameLabel.text = nil
        isUserInteractionEnabled = false
    }
}
