//
//  LineupsTableViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/27.
//

import UIKit

class LineupsTableViewCell: UITableViewCell {
    
    static let identifier = "LineupsTableViewCell"

    @IBOutlet weak var homePlayerLabel: UILabel!
    @IBOutlet weak var awayPlayerLabel: UILabel!
    @IBOutlet weak var homePlayerNumberLabel: UILabel!
    @IBOutlet weak var awayPlayerNumberLabel: UILabel!
    @IBOutlet weak var homePlayerPositionLabel: UILabel!
    @IBOutlet weak var awayPlayerPositionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewConfig()
    }
    
    private func viewConfig() {        
        [homePlayerLabel, homePlayerNumberLabel, homePlayerPositionLabel,
         awayPlayerLabel,awayPlayerNumberLabel, awayPlayerPositionLabel]
            .forEach {
                $0?.adjustsFontSizeToFitWidth = true
                $0?.font = .systemFont(ofSize: 13, weight: .medium)
            }
        
        homePlayerNumberLabel.textColor = .white
        awayPlayerNumberLabel.textColor = .white
        homePlayerNumberLabel.textAlignment = .center
        awayPlayerNumberLabel.textAlignment = .center
        homePlayerPositionLabel.textColor = .systemGray2
        awayPlayerPositionLabel.textColor = .systemGray2

    }
    
    func configure(homeLineup: LineupRealmData, awayLineup: LineupRealmData) {
        homePlayerLabel.text = homeLineup.name
        awayPlayerLabel.text = awayLineup.name        
        homePlayerPositionLabel.text = homeLineup.position
        awayPlayerPositionLabel.text = awayLineup.position
        homePlayerNumberLabel.text = homeLineup.name == "-" ? "-" : "\(homeLineup.number)"
        awayPlayerNumberLabel.text = awayLineup.name == "-" ? "-" : "\(awayLineup.number)"
    }
}
