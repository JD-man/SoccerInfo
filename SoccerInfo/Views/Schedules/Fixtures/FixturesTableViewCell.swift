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
    
    @IBOutlet weak var homeLogoImageView: UIImageView!
    @IBOutlet weak var awayLogoImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var noMatchCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewConfig()
    }
    
    func viewConfig() {
        backgroundColor = .secondarySystemGroupedBackground
        scoreLabel.isHidden = true
        timeLabel.isHidden = true        
        isUserInteractionEnabled = false
        
        scoreLabel.font = .systemFont(ofSize: 16, weight: .medium)
        timeLabel.font = .systemFont(ofSize: 15, weight: .medium)
        timeLabel.textColor = .systemGray
    }
    
    func configure(with data: FixturesContent) {        
        homeLogoImageView.kf.setImage(with: URL(string: data.homeLogo))
        awayLogoImageView.kf.setImage(with: URL(string: data.awayLogo))
        if let homeGoal = data.homeGoal, let awayGoal = data.awayGoal {
            accessoryType = .disclosureIndicator            
            isUserInteractionEnabled = true
            scoreLabel.isHidden = false
            timeLabel.isHidden = true            
            scoreLabel.text = "\(homeGoal) - \(awayGoal)"
            if UserDefaults.standard.value(forKey: "\(data.fixtureID)") != nil {
                UserDefaults.standard.removeObject(forKey: "\(data.fixtureID)")
            }
        }
        else {
            accessoryType = .checkmark
            isUserInteractionEnabled = true
            timeLabel.isHidden = false            
            scoreLabel.isHidden = true
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
        homeLogoImageView.image = nil
        awayLogoImageView.image = nil
        scoreLabel.text = nil
        timeLabel.text = nil
        accessoryType = .none
        tintColor = .gray
        isUserInteractionEnabled = false
    }
}
