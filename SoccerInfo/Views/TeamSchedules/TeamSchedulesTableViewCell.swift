//
//  TeamSchedulesTableViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2022/01/14.
//

import UIKit

class TeamSchedulesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var versusLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var homeAwayLabel: UILabel!
    @IBOutlet weak var scheduleDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewConfig()
    }
    
    private func viewConfig() {
        [versusLabel, resultLabel, homeAwayLabel]
            .forEach {
                $0?.text = nil
                $0?.textColor = .white
                $0?.textAlignment = .right
                $0?.font = .systemFont(ofSize: 16, weight: .medium)
            }
        scheduleDateLabel.text = nil
        scheduleDateLabel.textColor = .white
        scheduleDateLabel.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    func configure(with data: TeamScheduleCellModel) {
        if let homeGoal = data.homeGoal, let awayGoal = data.awayGoal {
            let selectedTeamGoal = data.isHomeTeam ? homeGoal : awayGoal
            let oppositeTeamGoal = data.isHomeTeam ? awayGoal : homeGoal
            let goalDiff = selectedTeamGoal - oppositeTeamGoal
            
            if goalDiff > 0 {
                resultLabel.textColor = .systemIndigo
            }
            else if goalDiff == 0 {
                resultLabel.textColor = .systemGreen
            }
            else {
                resultLabel.textColor = .systemPink
            }
            resultLabel.text = "\(selectedTeamGoal) : \(oppositeTeamGoal)"            
        }
        scheduleDateLabel.text = data.fixtureDate
        versusLabel.text = "vs \(data.oppsiteTeam)"
        homeAwayLabel.text = data.isHomeTeam ? "Home" : "Away"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resultLabel.text = nil
    }
}
