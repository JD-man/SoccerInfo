////
////  TeamSchedulesTableViewCell.swift
////  SoccerInfo
////
////  Created by JD_MacMini on 2022/01/14.
////
//
//import UIKit
//
//final class TeamSchedulesTableViewCell: UITableViewCell {
//    
//    private let versusLabel = TeamSchedulesLabel(fontSize: 16, fontWeight: .semibold, alignment: .right)
//    private let resultLabel = TeamSchedulesLabel(fontSize: 16, fontWeight: .semibold, alignment: .right)
//    private let homeAwayLabel = TeamSchedulesLabel(fontSize: 16, fontWeight: .semibold, alignment: .right)
//    private let scheduleDateLabel = TeamSchedulesLabel(fontSize: 18, fontWeight: .bold, alignment: .left)
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        viewConfig()
//        constraintsConfig()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func viewConfig() {
//        [scheduleDateLabel, versusLabel, homeAwayLabel, resultLabel].forEach {
//            contentView.addSubview($0)
//        }
//    }
//    
//    private func constraintsConfig() {
//        scheduleDateLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(10)
//            make.leading.equalToSuperview().offset(20)
//        }
//        
//        versusLabel.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().offset(-20)
//            make.top.equalTo(scheduleDateLabel.snp.bottom).offset(10)
//        }
//        
//        homeAwayLabel.snp.makeConstraints { make in
//            make.trailing.equalTo(versusLabel)
//            make.top.equalTo(versusLabel.snp.bottom).offset(10)
//        }
//        
//        resultLabel.snp.makeConstraints { make in
//            make.trailing.equalTo(versusLabel)
//            make.top.equalTo(homeAwayLabel.snp.bottom).offset(10)
//            make.bottom.equalToSuperview().offset(-10).priority(.low)
//        }
//    }
//    
//    func configure(with data: TeamScheduleCellModel) {
//        if let homeGoal = data.homeGoal, let awayGoal = data.awayGoal {
//            let selectedTeamGoal = data.isHomeTeam ? homeGoal : awayGoal
//            let oppositeTeamGoal = data.isHomeTeam ? awayGoal : homeGoal
//            let goalDiff = selectedTeamGoal - oppositeTeamGoal
//            
//            if goalDiff > 0 {
//                resultLabel.textColor = .systemIndigo
//            }
//            else if goalDiff == 0 {
//                resultLabel.textColor = .systemGreen
//            }
//            else {
//                resultLabel.textColor = .systemPink
//            }
//            resultLabel.text = "\(selectedTeamGoal) : \(oppositeTeamGoal)"            
//        }
//        scheduleDateLabel.text = data.fixtureDate
//        versusLabel.text = "vs \(data.oppsiteTeam)"
//        homeAwayLabel.text = data.isHomeTeam ? "Home" : "Away"
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        resultLabel.text = ""
//    }
//}
//
//extension TeamSchedulesTableViewCell {
//    private final class TeamSchedulesLabel: UILabel {
//        convenience init(fontSize: CGFloat,
//                         fontWeight: UIFont.Weight,
//                         alignment: NSTextAlignment) {
//            self.init(frame: .zero)
//            viewConfig(fontSize: fontSize, fontWeight: fontWeight, alignment: alignment)
//        }
//        
//        private func viewConfig(fontSize: CGFloat,
//                                fontWeight: UIFont.Weight,
//                                alignment: NSTextAlignment) {
//            textColor = .white
//            textAlignment = alignment
//            font = .systemFont(ofSize: fontSize, weight: fontWeight)
//        }
//    }
//}
