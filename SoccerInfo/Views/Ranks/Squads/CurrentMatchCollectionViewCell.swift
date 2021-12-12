//
//  CurrentMatchCollectionViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/12/12.
//

import UIKit

class CurrentMatchCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CurrentMatchCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        viewConfig()
    }
    
    func viewConfig() {
        addShadow()
        addCorner(rad: 10)
        backgroundColor = .systemYellow
    }

}
