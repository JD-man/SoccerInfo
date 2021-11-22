//
//  StandingsTableViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/22.
//

import UIKit

/*
 teamName
 teamLogo
 teamID
 played
 points
 win
 draw
 lose
 */

class StandingsTableViewCell: UITableViewCell {
    
    static let identifier = "StandingsTableViewCell"

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var playedLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var drawLabel: UILabel!
    @IBOutlet weak var loseLabel: UILabel!
    @IBOutlet weak var goalDiffLabel: UILabel!
    
    @IBOutlet weak var separateLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        separateLine.isHidden = true
    }
    
    func configure(with data: StandingsRealmData) {
        rankLabel.text = "\(data.rank)"
        teamNameLabel.text = data.teamName
        pointsLabel.text = "\(data.points)"
        playedLabel.text = "\(data.played)"
        winLabel.text = "\(data.win)"
        drawLabel.text = "\(data.draw)"
        loseLabel.text = "\(data.lose)"
        goalDiffLabel.text = "\(data.goalsDiff)"
        separateLine.isHidden = !(data.rank == 4 || data.rank == 6)
    }
}
