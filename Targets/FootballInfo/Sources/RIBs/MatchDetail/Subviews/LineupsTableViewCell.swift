//
//  LineupsTableViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/27.
//

import UIKit
import SnapKit

final class LineupsTableViewCell: UITableViewCell {
    private let seperator = UIView()
    private let homePlayerLabel = LineupLabel(color: .white)
    private let awayPlayerLabel = LineupLabel(color: .white)
    private let homePlayerNumberLabel = LineupLabel(color: .white, alignment: .center)
    private let awayPlayerNumberLabel = LineupLabel(color: .white, alignment: .center)
    private let homePlayerPositionLabel = LineupLabel(color: .systemGray2, alignment: .center)
    private let awayPlayerPositionLabel = LineupLabel(color: .systemGray2, alignment: .center)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewConfig()
        constraintsConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewConfig() {
        seperator.backgroundColor = .systemGray2
        [seperator, homePlayerLabel, homePlayerPositionLabel, homePlayerNumberLabel,
         awayPlayerNumberLabel, awayPlayerPositionLabel, awayPlayerLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func constraintsConfig() {
        seperator.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.top.bottom.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        homePlayerLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(seperator.snp.leading).offset(-5)
        }
        
        homePlayerNumberLabel.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(homePlayerLabel.snp.leading).offset(-5)
        }
        
        homePlayerPositionLabel.snp.makeConstraints { make in
            make.width.equalTo(15)
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalTo(homePlayerNumberLabel.snp.leading).offset(-5)
        }
        
        awayPlayerPositionLabel.snp.makeConstraints { make in
            make.width.equalTo(15)
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(seperator.snp.trailing).offset(5)
        }
        
        awayPlayerNumberLabel.snp.makeConstraints { make in
            make.leading.equalTo(awayPlayerPositionLabel.snp.trailing).offset(5)
            make.width.equalTo(30)
            make.top.bottom.equalToSuperview()
        }
        
        awayPlayerLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-5)
            make.leading.equalTo(awayPlayerNumberLabel.snp.trailing).offset(5)
        }
    }
    
  func configure(
    homeLineup: MatchDetailEntity.LineupEntity,
    awayLineup: MatchDetailEntity.LineupEntity,
    leagueInfo: LeagueInfo
  ) {
        homePlayerLabel.text = homeLineup.name
        awayPlayerLabel.text = awayLineup.name        
        homePlayerPositionLabel.text = homeLineup.position
        awayPlayerPositionLabel.text = awayLineup.position
        homePlayerNumberLabel.text = homeLineup.name == "-" ? "-" : "\(homeLineup.number)"
        awayPlayerNumberLabel.text = awayLineup.name == "-" ? "-" : "\(awayLineup.number)"
    backgroundColor = leagueInfo.league.colors[2]
    }
}

extension LineupsTableViewCell {
    private final class LineupLabel: UILabel {
        convenience init(color: UIColor, alignment: NSTextAlignment = .justified) {
            self.init(frame: .zero)
            viewConfig(color: color, alignment: alignment)
        }
        
        private func viewConfig(color: UIColor, alignment: NSTextAlignment) {
            textColor = color
            textAlignment = alignment
            adjustsFontSizeToFitWidth = true
            font = .systemFont(ofSize: 13, weight: .medium)
        }
    }
}
