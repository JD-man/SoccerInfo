//
//  EventsTableViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/27.
//

import UIKit
import SnapKit

final class EventsTableViewCell: UITableViewCell {
    private let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.layer.borderWidth = 0.5
        label.layer.cornerRadius = 15 // timeLabel width = 30
        label.layer.borderColor = UIColor.systemGray2.cgColor
        
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .white
        
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    private let homeDetailLabel = DetailLabel(alignment: .right)
    private let homePlayerNameLabel = PlayerNameLabel(alignment: .right)
    private lazy var homeStackView = EventStackView([homePlayerNameLabel, homeDetailLabel])
    
    private let awayDetailLabel = DetailLabel(alignment: .left)
    private let awayPlayerNameLabel = PlayerNameLabel(alignment: .left)
    private lazy var awayStackView = EventStackView([awayPlayerNameLabel, awayDetailLabel])
    
    private let homeEventTypeImageView = UIImageView()
    private let awayEventTypeImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewConfig()
        constraintsConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewConfig() {
        backgroundColor = .rgbColor(r: 11, g: 95, b: 25)
        [seperatorView, timeLabel,
         homeStackView, awayStackView,
         homeEventTypeImageView, awayEventTypeImageView].forEach { contentView.addSubview($0) }
    }
    
    private func constraintsConfig() {
        seperatorView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.center.equalToSuperview()
        }
        
        homeEventTypeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(timeLabel).multipliedBy(0.7)
            make.trailing.equalTo(timeLabel.snp.leading).offset(-10)
        }
        
        awayEventTypeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(homeEventTypeImageView)
            make.leading.equalTo(timeLabel.snp.trailing).offset(10)
        }
        
        homeStackView.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(homeEventTypeImageView.snp.leading).offset(-10)
        }
        
        awayStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(homeStackView)
            make.leading.equalTo(awayEventTypeImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
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
    
    private func homeTeamConfig(data: EventsRealmData) {
        let eventDetail = EventsDetail(rawValue: data.eventDetail.components(separatedBy: "-").first!)
        switch eventDetail {
        case .normalGoal:
            homeDetailLabel.text = data.assist
            homeEventTypeImageView.image = eventDetail?.eventsImage
        case .sub1, .sub2, .sub3, .sub4, .sub5:
            homeDetailLabel.text = data.assist
            if let awayImage = eventDetail?.eventsImage?.cgImage {
                let rotatedImage = UIImage(cgImage: awayImage,
                                           scale: 1.0,
                                           orientation: .upMirrored)
                homeEventTypeImageView.image = rotatedImage.withRenderingMode(.alwaysTemplate)
            }
        default :
            homeDetailLabel.text = data.eventDetail
            homeEventTypeImageView.image = eventDetail?.eventsImage
        }
        homePlayerNameLabel.text = data.player
        homeEventTypeImageView.tintColor = eventDetail?.eventsColor
    }
    
    private func awayTeamConfig(data: EventsRealmData) {
        let eventDetail = EventsDetail(rawValue: data.eventDetail.components(separatedBy: "-").first!)        
        switch eventDetail {
        case .normalGoal, .sub1, .sub2, .sub3, .sub4, .sub5:
            awayDetailLabel.text = data.assist
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
        homeDetailLabel.textColor = .lightGray
        awayDetailLabel.textColor = .lightGray
        homeDetailLabel.font = .systemFont(ofSize: 12, weight: .regular)
        awayDetailLabel.font = .systemFont(ofSize: 12, weight: .regular)
    }
}

extension EventsTableViewCell {
    enum EventsDetail: String {
        case normalGoal = "Normal Goal"
        case ownGoal = "Own Goal"
        case penalty = "Penalty"
        case missedPenalty = "Missed Penalty"
        case yellowCard = "Yellow Card"
        case secondYellowCard = "Card upgrade"
        case redCard = "Red Card"
        case sub1 = "Substitution 1"
        case sub2 = "Substitution 2"
        case sub3 = "Substitution 3"
        case sub4 = "Substitution 4"
        case sub5 = "Substitution 5"
        case goalCancelled = "Goal Disallowed "
        case penaltyConfirmed = "Penalty confirmed"
        
        var eventsColor: UIColor? {
            switch self {
            case .yellowCard:
                return UIColor.yellow
            case .secondYellowCard, .redCard:
                return UIColor.red
            default:
                return UIColor.white
            }
        }
        
        var eventsImage: UIImage? {
            switch self {
            case .normalGoal, .ownGoal, .penalty, .missedPenalty:
                return "⚽️".image()
            case .yellowCard, .secondYellowCard, .redCard:
                return UIImage(systemName: "lanyardcard.fill")
            case .sub1, .sub2, .sub3, .sub4, .sub5:
                return UIImage(systemName: "arrow.left.arrow.right")
            case .goalCancelled, .penaltyConfirmed:
                return UIImage(systemName: "arrow.triangle.2.circlepath.camera.fill")
            }
        }
    }
}

extension EventsTableViewCell {
    private final class PlayerNameLabel: UILabel {
        convenience init(alignment: NSTextAlignment) {
            self.init(frame: .zero)
            viewConfig(alignment: alignment)
        }
        
        private func viewConfig(alignment: NSTextAlignment) {
            numberOfLines = 0
            textColor = .white
            textAlignment = alignment
            adjustsFontSizeToFitWidth = true
            font = .systemFont(ofSize: 14, weight: .medium)
        }
    }
    
    private final class DetailLabel: UILabel {
        convenience init(alignment: NSTextAlignment) {
            self.init(frame: .zero)
            viewConfig(alignment: alignment)
        }
        
        private func viewConfig(alignment: NSTextAlignment) {
            numberOfLines = 0
            textColor = .lightGray
            textAlignment = alignment
            adjustsFontSizeToFitWidth = true
            font = .systemFont(ofSize: 12, weight: .regular)
        }
    }
    
    private final class EventStackView: UIStackView {
        convenience init(_ arrangedSubviews: [UIView]) {
            self.init(arrangedSubviews: arrangedSubviews)
            viewConfig()
        }
        
        private func viewConfig() {
            axis = .vertical
            distribution = .fillEqually
        }
    }
}
