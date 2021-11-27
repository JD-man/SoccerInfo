//
//  EventsTableViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/27.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    
    static let identifier = "EventsTableViewCell"
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var homeEventTypeImageView: UIImageView!
    @IBOutlet weak var homePlayerNameLabel: UILabel!
    @IBOutlet weak var awayEventTypeImageView: UIImageView!
    @IBOutlet weak var awayPlayerNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewConfig()
    }
    
    func viewConfig() {
        timeLabel.layer.borderWidth = 0.5
        timeLabel.layer.borderColor = UIColor.systemGray2.cgColor
        timeLabel.layer.cornerRadius = timeLabel.frame.width / 2
        timeLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        
    }
}
