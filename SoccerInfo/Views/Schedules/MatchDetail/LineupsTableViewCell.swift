//
//  LineupsTableViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/27.
//

import UIKit

class LineupsTableViewCell: UITableViewCell {
    
    static let identifier = "LineupsTableViewCell"

    @IBOutlet weak var homePlayer: UILabel!
    @IBOutlet weak var homePlayerNumber: UILabel!
    @IBOutlet weak var homePlayerPosition: UILabel!
    
    @IBOutlet weak var awayPlayer: UILabel!
    @IBOutlet weak var awayPlayerNumber: UILabel!
    @IBOutlet weak var awayPlayerPosition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewConfig()
    }
    
    func viewConfig() {
        
        [homePlayer, homePlayerNumber, homePlayerPosition,
         awayPlayer,awayPlayerNumber, awayPlayerPosition].forEach {
            $0?.font = .systemFont(ofSize: 13, weight: .medium)
        }
        homePlayerPosition.textColor = .systemGray2
        awayPlayerPosition.textColor = .systemGray2
        homePlayerNumber.textAlignment = .center
        awayPlayerNumber.textAlignment = .center
        backgroundColor = .tertiarySystemGroupedBackground
    }
    
    func configure(homeLineup: LineupRealmData, awayLineup: LineupRealmData) {
        homePlayer.text = homeLineup.name
        homePlayerNumber.text = "\(homeLineup.number)"
        homePlayerPosition.text = homeLineup.position
        
        awayPlayer.text = awayLineup.name
        awayPlayerNumber.text = "\(awayLineup.number)"
        awayPlayerPosition.text = awayLineup.position
    }
}
