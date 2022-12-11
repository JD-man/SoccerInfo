//
//  StandingSectionHeaderView.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/22.
//

import UIKit
import SnapKit

final class StandingSectionHeaderView: UIView {
    static let identifier = "StandingSectionHeaderView"
    
    private let rankLabel = StandingSectionLabel(title: "순위")
    private let teamNameLabel = StandingSectionLabel(title: "팀")
    private let pointsLabel = StandingSectionLabel(title: "승점")
    private let playedLabel = StandingSectionLabel(title: "경기")
    private let winLabel = StandingSectionLabel(title: "승")
    private let drawLabel = StandingSectionLabel(title: "무")
    private let loseLabel = StandingSectionLabel(title: "패")
    private let goalDiffLabel = StandingSectionLabel(title: "득실")
    
    private lazy var infoStackView: UIStackView = {
        let labels = [pointsLabel, playedLabel, winLabel, drawLabel, loseLabel, goalDiffLabel]
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        viewConfig()
        constraintsConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewConfig() {
        backgroundColor = PublicPropertyManager.shared.league.colors[2]
        [rankLabel, teamNameLabel, infoStackView].forEach { addSubview($0) }
        
        // headerview corner config
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    private func constraintsConfig() {
        /*
         rank: leading +15, centerY, width 0.07
         team: leading + 5, centerY
         stack: trailing -15, centerY, width 0.5, leading +5, top +10, bottom - 10
         */
        rankLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.07)
        }
        
        teamNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(rankLabel.snp.trailing).offset(5)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(teamNameLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-15)
        }
        
    }
}

extension StandingSectionHeaderView {
    private final class StandingSectionLabel: UILabel {
        convenience init(title: String) {
            self.init(frame: .zero)
            viewConfig(title: title)
        }
        
        private func viewConfig(title: String) {
            text = title
            textAlignment = .center
            textColor = .white
            font = .systemFont(ofSize: 15, weight: .semibold)
        }
    }
}
