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
        
        homeAwayLabel.text = "Home"
        scoreLabel.text = "\(homeGoal) : \(awayGoal)"
        winLoseLabelConfig(teamGoal: homeGoal, oppositeGoal: awayGoal)
        opposingTeamLogoImageView.kf.setImage(with: URL(string: data.awayLogo))
    }
    
    private func awayConfigure(data: FixturesRealmData) {
        let homeGoal = data.homeGoal!
        let awayGoal = data.awayGoal!
        
        homeAwayLabel.text = "Away"
        scoreLabel.text = "\(awayGoal) : \(homeGoal)"
        winLoseLabelConfig(teamGoal: awayGoal, oppositeGoal: homeGoal)
        opposingTeamLogoImageView.kf.setImage(with: URL(string: data.homeLogo))
    }
    
    private func winLoseLabelConfig(teamGoal: Int, oppositeGoal: Int) {
        if teamGoal > oppositeGoal {
            winLoseLabel.text = "Win!"
            winLoseLabel.textColor = .systemIndigo
        }
        else if teamGoal < oppositeGoal {
            winLoseLabel.text = "Lose..."
            winLoseLabel.textColor = .systemPink
        }
        else {
            winLoseLabel.text = "Draw"
            winLoseLabel.textColor = .systemGreen
        }
    }
}
