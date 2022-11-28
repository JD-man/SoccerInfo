//
//  SideTableViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/23.
//

import UIKit
import SnapKit

final class SideTableViewCell: UITableViewCell {
    private let leagueNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewConfig()
        constraintsConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewConfig() {
        contentView.addSubview(leagueNameLabel)
        backgroundColor = PublicPropertyManager.shared.league.colors[2]
    }
    
    private func constraintsConfig() {
        leagueNameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func configure(with leagueName: String) {
        leagueNameLabel.text = leagueName
    }
}
