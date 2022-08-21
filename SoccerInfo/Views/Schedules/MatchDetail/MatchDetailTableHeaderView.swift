//
//  MatchDetailTableHeaderView.swift
//  SoccerInfo
//
//  Created by 조동현 on 2022/08/21.
//

import UIKit
import SnapKit

final class MatchDetailTableHeaderView: UIView {
    private let versusLabel = MatchDetailScoreLabel()
    private let homeScoreLabel = MatchDetailScoreLabel()
    private let awayScoreLabel = MatchDetailScoreLabel()
    private let homeTeamNameLabel = MatchDetailTeamNameLabel()
    private let awayTeamNameLabel = MatchDetailTeamNameLabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        viewConfig()
        constraintsConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewConfig() {
        addCorner()
        versusLabel.text = ":"
        frame.size.height = 160
        backgroundColor = PublicPropertyManager.shared.league.colors[2]
        
        [versusLabel,
         homeScoreLabel, awayScoreLabel,
         homeTeamNameLabel, awayTeamNameLabel].forEach { addSubview($0) }
    }
    
    private func constraintsConfig() {
        versusLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.75)
        }
        
        homeTeamNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        awayTeamNameLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(homeTeamNameLabel)
            make.leading.equalTo(homeTeamNameLabel.snp.trailing)
        }
        
        homeScoreLabel.snp.makeConstraints { make in
            make.centerY.equalTo(versusLabel)
            make.centerX.equalTo(homeTeamNameLabel)
            make.bottom.equalTo(homeTeamNameLabel.snp.top).offset(-10)
        }
        
        awayScoreLabel.snp.makeConstraints { make in
            make.centerY.equalTo(versusLabel)
            make.bottom.equalTo(homeScoreLabel)
            make.centerX.equalTo(awayTeamNameLabel)
        }
    }
    
    func configure(homeScore: Int, awayScore: Int, homeTeamName: String, awayTeamName: String) {
        homeScoreLabel.text = "\(homeScore)"
        awayScoreLabel.text = "\(awayScore)"
        homeTeamNameLabel.text = homeTeamName.uppercased().modifyTeamName
        awayTeamNameLabel.text = awayTeamName.uppercased().modifyTeamName
    }
}

extension MatchDetailTableHeaderView {
    private final class MatchDetailScoreLabel: UILabel {
        convenience init() {
            self.init(frame: .zero)
            viewConfig()
        }
        
        private func viewConfig() {
            textColor = .white
            font = .systemFont(ofSize: 45, weight: .semibold)
        }
    }
    
    private final class MatchDetailTeamNameLabel: UILabel {
        convenience init() {
            self.init(frame: .zero)
            viewConfig()
        }
        
        private func viewConfig() {
            numberOfLines = 0
            textAlignment = .center
            adjustsFontSizeToFitWidth = true
            font = .systemFont(ofSize: 20, weight: .bold)
            textColor = PublicPropertyManager.shared.league.colors[1]
        }
    }
}
