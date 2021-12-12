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
    
    func viewConfigure(with data: FixturesRealmData) {
        
    }
}
