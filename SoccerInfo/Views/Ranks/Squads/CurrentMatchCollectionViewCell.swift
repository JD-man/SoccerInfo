//
//  CurrentMatchCollectionViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/12/12.
//

import UIKit
import Kingfisher

class CurrentMatchCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CurrentMatchCollectionViewCell"
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var winLoseLabel: UILabel!
    @IBOutlet weak var homeAwayLabel: UILabel!
    @IBOutlet weak var opposingTeamLogoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewConfig()
    }
    
    private func viewConfig() {
        addCorner(rad: 10)        
    }
    
    func configure(with data: FixturesRealmData, isHome: Bool) {
        if isHome {
            homeConfigure(data: data)
        }
        else {
            awayConfigure(data: data)
        }
    }
    
    private func homeConfigure(data: FixturesRealmData) {
        let homeGoal = data.homeGoal!
        let awayGoal = data.awayGoal!
        
        scoreLabel.text = "\(homeGoal) : \(awayGoal)"
        homeAwayLabel.text = "Home"
        opposingTeamLogoImageView.kf.setImage(with: URL(string: data.awayLogo))
        
        if homeGoal > awayGoal {
            winLoseLabel.text = "Win!"
        }
        else if homeGoal < awayGoal {
            winLoseLabel.text = "Lose..."
        }
        else {
            winLoseLabel.text = "Draw"
        }
    }
    
    private func awayConfigure(data: FixturesRealmData) {
        let homeGoal = data.homeGoal!
        let awayGoal = data.awayGoal!
        
        scoreLabel.text = "\(awayGoal) : \(homeGoal)"
        homeAwayLabel.text = "Away"
        opposingTeamLogoImageView.kf.setImage(with: URL(string: data.homeLogo))
        
        if awayGoal > homeGoal {
            winLoseLabel.text = "Win!"
        }
        else if awayGoal < homeGoal {
            winLoseLabel.text = "Lose..."
        }
        else {
            winLoseLabel.text = "Draw"
        }
    }
    
}
