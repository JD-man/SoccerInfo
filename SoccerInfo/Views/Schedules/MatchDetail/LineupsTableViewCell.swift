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
    @IBOutlet weak var awayPlayer: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(homeLineup: LineupRealmData, awayLineup: LineupRealmData) {
        homePlayer.text = homeLineup.name
        awayPlayer.text = awayLineup.name
    }
}
