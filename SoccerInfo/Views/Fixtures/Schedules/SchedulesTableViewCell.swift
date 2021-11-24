//
//  SchedulesTableViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/24.
//

import UIKit
import Kingfisher

class SchedulesTableViewCell: UITableViewCell {
    
    typealias ScheduleContent = (String, String, Int?, Int?, String)
    static let identifier = "SchedulesTableViewCell"

    
    @IBOutlet weak var homeLogoImageView: UIImageView!
    @IBOutlet weak var awayLogoImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scoreLabel.isHidden = true
        timeLabel.isHidden = true
    }
    
    func configure(with data: ScheduleContent) {
        homeLogoImageView.kf.setImage(with: URL(string: data.0))
        awayLogoImageView.kf.setImage(with: URL(string: data.1))
        if let homeGoal = data.2, let awayGoal = data.3 {
            scoreLabel.isHidden = false
            scoreLabel.text = "\(homeGoal) - \(awayGoal)"
        }
        else {
            timeLabel.isHidden = false
            timeLabel.text = "\(data.4)"
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scoreLabel.isHidden = true
        timeLabel.isHidden = true
    }
}
