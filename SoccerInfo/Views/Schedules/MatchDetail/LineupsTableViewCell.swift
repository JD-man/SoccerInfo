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
    @IBOutlet weak var homePlayerNumberLabel: UILabel!
    @IBOutlet weak var homePlayerPositionLabel: UILabel!
    
    @IBOutlet weak var awayPlayerLabel: UILabel!
    @IBOutlet weak var awayPlayerNumberLabel: UILabel!
    @IBOutlet weak var awayPlayerPositionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewConfig()
    }
    
    func viewConfig() {        
        [homePlayerLabel, homePlayerNumberLabel, homePlayerPositionLabel,
         awayPlayerLabel,awayPlayerNumberLabel, awayPlayerPositionLabel].forEach {
            $0?.font = .systemFont(ofSize: 13, weight: .medium)
        }
        homePlayerPositionLabel.textColor = .systemGray2
        awayPlayerPositionLabel.textColor = .systemGray2
        homePlayerNumberLabel.textAlignment = .center
        awayPlayerNumberLabel.textAlignment = .center
    }
    
    func configure(homeLineup: LineupRealmData, awayLineup: LineupRealmData) {
        homePlayerLabel.text = homeLineup.name
        homePlayerPositionLabel.text = homeLineup.position
        homePlayerNumberLabel.text = homeLineup.name == "-" ? "-" : "\(homeLineup.number)"
        
        awayPlayerLabel.text = awayLineup.name
        awayPlayerPositionLabel.text = awayLineup.position        
        awayPlayerNumberLabel.text = awayLineup.name == "-" ? "-" : "\(awayLineup.number)"
    }
}
