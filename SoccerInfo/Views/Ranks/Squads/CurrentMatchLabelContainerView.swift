//
//  CurrentMatchLabelContainerView.swift
//  SoccerInfo
//
//  Created by 조동현 on 2022/08/25.
//

import UIKit

final class CurrentMatchLabelContainerView: UIView {
    private let teamNameLabel = CurrentMatchLabel(size: 24, weight: .bold)
    private let currentRankLabel = CurrentMatchLabel(size: 19, weight: .medium)
    private let rankDescriptionLabel = CurrentMatchLabel(size: 15, weight: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        viewConfig()
        constraintsConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewConfig() {
        addShadow()
        addCorner(rad: 10)
        currentRankLabel.text = "현재 순위"
        backgroundColor = .systemBackground
        [teamNameLabel, rankDescriptionLabel, currentRankLabel]
            .forEach { addSubview($0) }
    }
    
    private func constraintsConfig() {
        teamNameLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(10)
        }
        
        rankDescriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(teamNameLabel.snp.bottom).offset(10)
        }
        
        currentRankLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(teamNameLabel)
            make.top.equalTo(rankDescriptionLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configure(teamName: String, rank: Int) {
        teamNameLabel.text = teamName
        rankDescriptionLabel.text = "\(rank)등"
    }
}

extension CurrentMatchLabelContainerView {
    private final class CurrentMatchLabel: UILabel {
        convenience init(size: CGFloat, weight: UIFont.Weight) {
            self.init(frame: .zero)
            viewConfig(size: size, weight: weight)
        }
        
        private func viewConfig(size: CGFloat, weight: UIFont.Weight) {
            textColor = .label
            textAlignment = .center
            adjustsFontSizeToFitWidth = true
            font = .systemFont(ofSize: size, weight: weight)
        }
    }
}
