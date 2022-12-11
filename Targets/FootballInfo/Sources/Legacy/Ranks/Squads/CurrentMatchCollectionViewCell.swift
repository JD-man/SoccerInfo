//
//  CurrentMatchCollectionViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/12/12.
//

import UIKit

final class CurrentMatchCollectionViewCell: UICollectionViewCell {
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chevron.right")
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    private let versusLabel = CurrentMatchLabel(size: 14, weight: .medium)
    private let scoreLabel = CurrentMatchLabel(size: 17, weight: .regular)
    private let winLoseLabel = CurrentMatchLabel(size: 17, weight: .medium)
    private let homeAwayLabel = CurrentMatchLabel(size: 17, weight: .medium)
    private let oppositeTeamNameLabel = CurrentMatchLabel(size: 18, weight: .heavy)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
        constraintsConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewConfig() {
        addCorner(rad: 10)
        versusLabel.text = "VS"
        [chevronImageView, versusLabel, scoreLabel,
         winLoseLabel, homeAwayLabel, oppositeTeamNameLabel]
            .forEach { contentView.addSubview($0) }
    }
    
    private func constraintsConfig() {
        chevronImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.05)
            make.trailing.equalToSuperview().offset(-10)
            make.top.bottom.equalToSuperview()
        }
        
        oppositeTeamNameLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-10)
        }
        
        versusLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(0.25)
            make.trailing.equalTo(oppositeTeamNameLabel.snp.leading).offset(-10)
            make.width.height.equalTo(oppositeTeamNameLabel.snp.height)
            make.bottom.equalTo(oppositeTeamNameLabel)
        }
        
        homeAwayLabel.snp.makeConstraints { make in
            make.leading.equalTo(versusLabel)
            make.trailing.equalTo(oppositeTeamNameLabel)
            make.top.equalTo(versusLabel.snp.bottom).offset(20)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.leading.equalTo(versusLabel)
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalTo(homeAwayLabel.snp.bottom).offset(10)
        }
        
        winLoseLabel.snp.makeConstraints { make in
            make.leading.equalTo(scoreLabel.snp.trailing).offset(10)
            make.trailing.equalTo(oppositeTeamNameLabel)
            make.top.bottom.equalTo(scoreLabel)
        }
    }
    
    func configure(with data: FixturesRealmData, isHome: Bool) {
        if isHome {
            homeConfigure(data: data)
        }
        else {
            awayConfigure(data: data)
        }
    }
    
    private func homeConfigure(data: FixturesRealmData) {
        let homeGoal = data.homeGoal!
        let awayGoal = data.awayGoal!
        
        homeAwayLabel.text = "Home"
        scoreLabel.text = "\(homeGoal) : \(awayGoal)"
        winLoseLabelConfig(teamGoal: homeGoal, oppositeGoal: awayGoal)
        //oppositeTeamNameLabel.text = LocalizationList.team[data.awayID] ?? ""
    }
    
    private func awayConfigure(data: FixturesRealmData) {
        let homeGoal = data.homeGoal!
        let awayGoal = data.awayGoal!
        
        homeAwayLabel.text = "Away"
        scoreLabel.text = "\(awayGoal) : \(homeGoal)"
        winLoseLabelConfig(teamGoal: awayGoal, oppositeGoal: homeGoal)
        //oppositeTeamNameLabel.text = LocalizationList.team[data.homeID] ?? ""
    }
    
    private func winLoseLabelConfig(teamGoal: Int, oppositeGoal: Int) {
        if teamGoal > oppositeGoal {
            winLoseLabel.text = "WIN!"
            winLoseLabel.textColor = .systemIndigo
        }
        else if teamGoal < oppositeGoal {
            winLoseLabel.text = "LOSE..."
            winLoseLabel.textColor = .systemPink
        }
        else {
            winLoseLabel.text = "DRAW"
            winLoseLabel.textColor = .systemGreen
        }
    }
}

extension CurrentMatchCollectionViewCell {
    private final class CurrentMatchLabel: UILabel {
        convenience init(size: CGFloat, weight: UIFont.Weight) {
            self.init(frame: .zero)
            textColor = .white
            font = .systemFont(ofSize: size, weight: weight)
        }
    }
}
