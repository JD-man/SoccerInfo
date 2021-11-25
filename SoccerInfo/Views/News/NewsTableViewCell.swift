//
//  NewsTableViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/25.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    
    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var newsTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }
    
    func configure(with data: UIView) {
        
    }
}
