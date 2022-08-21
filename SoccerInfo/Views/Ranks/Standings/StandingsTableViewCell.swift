//
//  StandingsTableViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/22.
//

import UIKit

final class StandingsTableViewCell: UITableViewCell {
    private let rankLabel = UILabel()
    private let teamNameLabel = UILabel()
    
    private let pointsLabel = UILabel()
    private let playedLabel = UILabel()
    private let winLabel = UILabel()
    private let drawLabel = UILabel()
    private let loseLabel = UILabel()
    private let goalDiffLabel = UILabel()
    
    private lazy var infoStackView: UIStackView = {
        let labels = [pointsLabel, playedLabel, winLabel, drawLabel, loseLabel, goalDiffLabel]
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let separateLine = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewConfig()
        configrationConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewConfig() {
        
        [rankLabel, teamNameLabel, infoStackView, separateLine].forEach {
            contentView.addSubview($0)
        }
        
        [playedLabel, winLabel, drawLabel, loseLabel, goalDiffLabel].forEach {
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 15, weight: .regular)
            $0.textColor = .systemBackground
        }
        
        zip([rankLabel, pointsLabel, teamNameLabel],
            [UIFont.Weight.semibold, UIFont.Weight.semibold, UIFont.Weight.medium])
        .forEach { label, weight in
            label.font = .systemFont(ofSize: 15, weight: weight)
            label.textAlignment = .center
            label.textColor = .systemBackground
        }
        
        separateLine.isHidden = true
        separateLine.backgroundColor = .systemGray2
        backgroundColor = .clear
    }
    
    private func configrationConfig() {
        rankLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.07)
        }
        
        teamNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(rankLabel.snp.trailing).offset(20)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.leading.equalTo(teamNameLabel.snp.trailing).offset(8)
            make.height.equalTo(infoStackView.snp.width).multipliedBy(0.36)
        }
        
        separateLine.snp.makeConstraints { make in
            make.height.equalTo(1.5)
            make.bottom.equalToSuperview()
            make.leading.equalTo(rankLabel)
            make.trailing.equalTo(infoStackView)
        }
    }
    
    func configure(with data: StandingsRealmData) {
        rankLabel.text = "\(data.rank)"
        teamNameLabel.text = LocalizationList.team[data.teamID] ?? ""
        
        pointsLabel.text = "\(data.points)"
        playedLabel.text = "\(data.played)"
        
        winLabel.text = "\(data.win)"
        drawLabel.text = "\(data.draw)"
        loseLabel.text = "\(data.lose)"
        goalDiffLabel.text = "\(data.goalsDiff)"
        
        separateLineConfig(rank: data.rank)
    }
    
    private func separateLineConfig(rank: Int) {
        switch PublicPropertyManager.shared.league {
        case .premierLeague:
            separateLine.isHidden = !(rank == 4 || rank == 6 || rank == 17)
        case .laLiga:
            separateLine.isHidden = !(rank == 4 || rank == 7 || rank == 17)
        case .serieA:
            separateLine.isHidden = !(rank == 4 || rank == 7 || rank == 17)
        case .bundesliga:
            separateLine.isHidden = !(rank == 4 || rank == 7 || rank == 16)
        case .ligue1:
            separateLine.isHidden = !(rank == 2 || rank == 4 || rank == 18)
        }
    }
}
