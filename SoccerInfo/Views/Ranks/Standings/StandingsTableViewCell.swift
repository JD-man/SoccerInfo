//
//  StandingsTableViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/22.
//

import UIKit

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
        viewConfig()
    }
    
    private func viewConfig() {        
        separateLine.isHidden = true
        rankLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        pointsLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        backgroundColor = .clear        
    }
    
    func configure(with data: StandingsRealmData) {
        rankLabel.text = "\(data.rank)"
        teamNameLabel.text = LocalizationList.team[data.teamID] ?? ""
        
        pointsLabel.text = "\(data.points)"
        playedLabel.text = "\(data.played)"
        
        winLabel.text = "\(data.win)"
        drawLabel.text = "\(data.draw)"
        loseLabel.text = "\(data.lose)"
        goalDiffLabel.text = "\(data.goalsDiff)"
        
        separateLineConfig(rank: data.rank)
    }
    
    func separateLineConfig(rank: Int) {
        switch PublicPropertyManager.shared.league {
        case .premierLeague:
            separateLine.isHidden = !(rank == 4 || rank == 6 || rank == 17)
        case .laLiga:
            separateLine.isHidden = !(rank == 4 || rank == 7 || rank == 17)
        case .serieA:
            separateLine.isHidden = !(rank == 4 || rank == 7 || rank == 17)
        case .bundesliga:
            separateLine.isHidden = !(rank == 4 || rank == 7 || rank == 16)
        case .ligue1:
            separateLine.isHidden = !(rank == 2 || rank == 4 || rank == 18)
        }
    }
}
