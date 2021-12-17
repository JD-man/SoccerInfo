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
    @IBOutlet weak var oppositeTeamNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewConfig()
    }
    
    private func viewConfig() {
        addCorner(rad: 10)
        oppositeTeamNameLabel.font = .systemFont(ofSize: 18, weight: .heavy)
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
        oppositeTeamNameLabel.text = LocalizationList.team[data.awayID] ?? ""
    }
    
    private func awayConfigure(data: FixturesRealmData) {
        let homeGoal = data.homeGoal!
        let awayGoal = data.awayGoal!
        
        homeAwayLabel.text = "Away"
        scoreLabel.text = "\(awayGoal) : \(homeGoal)"
        winLoseLabelConfig(teamGoal: awayGoal, oppositeGoal: homeGoal)
        oppositeTeamNameLabel.text = LocalizationList.team[data.homeID] ?? ""
    }
    
    private func winLoseLabelConfig(teamGoal: Int, oppositeGoal: Int) {
        if teamGoal > oppositeGoal {
            winLoseLabel.text = "WIN!"
            winLoseLabel.textColor = .systemIndigo
        }
        else if teamGoal < oppositeGoal {
            winLoseLabel.text = "LOSE..."
            winLoseLabel.textColor = .systemPink
        }
        else {
            winLoseLabel.text = "DRAW"
            winLoseLabel.textColor = .systemGreen
        }
    }
}
