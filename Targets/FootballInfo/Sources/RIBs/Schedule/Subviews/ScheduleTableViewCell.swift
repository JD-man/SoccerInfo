//
//  SchedulesTableViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/24.
//

import UIKit
import SnapKit

final class ScheduleTableViewCell: UITableViewCell {
  private let homeNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.textAlignment = .right
    label.font = .systemFont(ofSize: 15, weight: .semibold)
    return label
  }()
  
  private let awayNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.textAlignment = .left
    label.font = .systemFont(ofSize: 15, weight: .semibold)
    return label
  }()
  
  private let scoreLabel: UILabel = {
    let label = UILabel()
    label.isHidden = true
    label.textColor = .white
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 13, weight: .medium)
    return label
  }()
  private let timeLabel: UILabel = {
    let label = UILabel()
    label.isHidden = true
    label.textColor = .systemGray
    label.font = .systemFont(ofSize: 12, weight: .medium)
    return label
  }()
  
  let noMatchCellLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .systemGray2
    label.font = .systemFont(ofSize: 20, weight: .semibold)
    label.text = "경기가 없습니다!"
    label.isHidden = true
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    viewConfig()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func viewConfig() {
    isUserInteractionEnabled = false
    [homeNameLabel, awayNameLabel, scoreLabel, timeLabel, noMatchCellLabel].forEach {
      contentView.addSubview($0)
    }
    
    scoreLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.13)
      make.height.equalToSuperview().multipliedBy(0.3)
    }
    
    timeLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    homeNameLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(8)
      make.trailing.equalTo(scoreLabel.snp.leading).offset(-8)
      make.centerY.equalToSuperview()
    }
    
    awayNameLabel.snp.makeConstraints { make in
      make.leading.equalTo(scoreLabel.snp.trailing).offset(8)
      make.trailing.equalToSuperview().offset(-8)
      make.centerY.equalToSuperview()
    }
    
    noMatchCellLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  func configure(with data: ScheduleSectionModel.Item) {
    
    if data.homeName == "empty" {
      noMatchCellLabel.isHidden = false
      return
    }
    
    homeNameLabel.text = LocalizationList.team[data.homeID] ?? ""
    awayNameLabel.text = LocalizationList.team[data.awayID] ?? ""
    if let homeGoal = data.homeGoal, let awayGoal = data.awayGoal {
      timeLabel.isHidden = true
      scoreLabel.isHidden = false
      isUserInteractionEnabled = true
      scoreLabel.text = "\(homeGoal) - \(awayGoal)"
      
      tintColor = .gray
      accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
      if UserDefaults.standard.value(forKey: "\(data.fixtureID)") != nil {
        UserDefaults.standard.removeObject(forKey: "\(data.fixtureID)")
      }
    }        
    else {            
      scoreLabel.isHidden = true
      timeLabel.isHidden = false
      isUserInteractionEnabled = true
      timeLabel.text = "\(data.matchHour)"
      
      accessoryView = UIImageView(image: UIImage(systemName: "checkmark"))
      // set accessory color by UserDefaults reserved fixture array
      if let reserveds = UserDefaults.standard.value(forKey: "ReservedFixtures") as? [Int] {
        tintColor = reserveds.contains(data.fixtureID) ? .link : .gray
      }
      else {
        tintColor = .gray
      }
    }        
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    tintColor = .gray
    timeLabel.text = nil
    scoreLabel.text = nil
    accessoryView = nil
    homeNameLabel.text = nil
    awayNameLabel.text = nil
    isUserInteractionEnabled = false
    noMatchCellLabel.isHidden = true
  }
}
