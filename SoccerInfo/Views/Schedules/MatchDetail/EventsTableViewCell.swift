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
    
    @IBOutlet weak var homeDetailLabel: UILabel!
    @IBOutlet weak var awayDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewConfig()
    }
    
    func viewConfig() {
        [timeLabel, homePlayerNameLabel, awayPlayerNameLabel, homeDetailLabel, awayDetailLabel]
            .forEach {
                $0?.adjustsFontSizeToFitWidth = true
            }
        timeLabel.clipsToBounds = true
        timeLabel.layer.borderWidth = 0.5
        timeLabel.layer.borderColor = UIColor.systemGray2.cgColor
        timeLabel.layer.cornerRadius = timeLabel.frame.width / 2
        timeLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        
        homePlayerNameLabel.numberOfLines = 0
        awayPlayerNameLabel.numberOfLines = 0
        homePlayerNameLabel.textColor = .systemBackground
        awayPlayerNameLabel.textColor = .systemBackground
        homePlayerNameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        awayPlayerNameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        homeDetailLabel.textColor = .systemGray2
        awayDetailLabel.textColor = .systemGray2
        homeDetailLabel.font = .systemFont(ofSize: 12, weight: .regular)
        awayDetailLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        backgroundColor = UIColor(red: 11/255, green: 70/255, blue: 25/255, alpha: 1)
    }
    
    func configure(with data: EventsRealmData, isHomeCell: Bool) {        
        if isHomeCell {
            homeTeamConfig(data: data)
        }
        else {
            awayTeamConfig(data: data)
        }
        timeLabel.text = "\(data.time)"
    }
    
    func homeTeamConfig(data: EventsRealmData) {
        let eventDetail = EventsDetail(rawValue: data.eventDetail.components(separatedBy: "-").first!)
        switch eventDetail {
        case .normalGoal:
            homeDetailLabel.text = data.assist
        case .sub1, .sub2, .sub3, .sub4, .sub5:
            homeDetailLabel.text = data.assist
            homeDetailLabel.textColor = .systemBackground
            homeDetailLabel.font = .systemFont(ofSize: 14, weight: .medium)
        default :
            homeDetailLabel.text = data.eventDetail
        }
        homePlayerNameLabel.text = data.player
        homeEventTypeImageView.image = eventDetail?.eventsImage
        homeEventTypeImageView.tintColor = eventDetail?.eventsColor
    }
    
    func awayTeamConfig(data: EventsRealmData) {
        let eventDetail = EventsDetail(rawValue: data.eventDetail.components(separatedBy: "-").first!)        
        switch eventDetail {
        case .normalGoal:
            awayDetailLabel.text = data.assist
        case .sub1, .sub2, .sub3, .sub4, .sub5:
            awayDetailLabel.text = data.assist
            awayDetailLabel.textColor = .systemBackground
            awayDetailLabel.font = .systemFont(ofSize: 14, weight: .medium)
        default :
            awayDetailLabel.text = data.eventDetail
        }
        awayPlayerNameLabel.text = data.player
        awayEventTypeImageView.image = eventDetail?.eventsImage
        awayEventTypeImageView.tintColor = eventDetail?.eventsColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = nil
        homeDetailLabel.text = nil
        awayDetailLabel.text = nil
        homePlayerNameLabel.text = nil
        awayPlayerNameLabel.text = nil        
        homeEventTypeImageView.image = nil
        awayEventTypeImageView.image = nil
        homeDetailLabel.textColor = .systemGray2
        awayDetailLabel.textColor = .systemGray2
        homeDetailLabel.font = .systemFont(ofSize: 12, weight: .regular)
        awayDetailLabel.font = .systemFont(ofSize: 12, weight: .regular)
    }
    
    enum EventsDetail: String {
        case normalGoal = "Normal Goal"
        case ownGoal = "Own Goal"
        case penalty = "Penalty"
        case missedPenalty = "Missed Penalty"
        case yellowCard = "Yellow Card"
        case secondYellowCard = "Second Yellow card"
        case redCard = "Red Card"
        case sub1 = "Substitution 1"
        case sub2 = "Substitution 2"
        case sub3 = "Substitution 3"
        case sub4 = "Substitution 4"
        case sub5 = "Substitution 5"
        case goalCancelled = "Goal Disallowed "
        case penaltyConfirmed = "Penalty confirmed"
        
        var eventsImage: UIImage? {
            switch self {
            case .normalGoal, .ownGoal, .penalty, .missedPenalty:
                return "⚽️".image()
            case .yellowCard, .secondYellowCard, .redCard:
                return UIImage(systemName: "lanyardcard.fill")
            case .sub1, .sub2, .sub3, .sub4, .sub5:
                return UIImage(systemName: "arrow.triangle.capsulepath")
            case .goalCancelled, .penaltyConfirmed:
                return UIImage(systemName: "arrow.triangle.2.circlepath.camera.fill")
            }
        }
        
        var eventsColor: UIColor? {
            switch self {
            case .yellowCard:
                return UIColor.yellow
            case .secondYellowCard, .redCard:
                return UIColor.red
            default:
                return UIColor.systemBackground
            }
        }
    }
}
