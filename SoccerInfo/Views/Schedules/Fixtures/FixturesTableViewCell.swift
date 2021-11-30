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
        selectionStyle = .none
        isUserInteractionEnabled = false
        
        scoreLabel.font = .systemFont(ofSize: 17, weight: .medium)
        timeLabel.font = .systemFont(ofSize: 17, weight: .medium)
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
        }
        else {
            accessoryType = .none
            isUserInteractionEnabled = false
            timeLabel.isHidden = false            
            scoreLabel.isHidden = true
            timeLabel.text = "\(data.matchHour)"
        }        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        homeLogoImageView.image = nil
        awayLogoImageView.image = nil
        scoreLabel.text = nil
        timeLabel.text = nil
        accessoryType = .none
        isUserInteractionEnabled = false
    }
}
