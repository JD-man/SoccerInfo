//
//  FormationSectionHeaderView.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/12/05.
//

import UIKit
import SnapKit

final class FormationSectionFooterView: UIView {
    
    private let homeFormationLabel = FormationFooterLabel()
    private let awayFormationLabel = FormationFooterLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
        constraintsConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewConfig() {
        backgroundColor = .clear
        [homeFormationLabel, awayFormationLabel].forEach { addSubview($0) }
    }
    
    private func constraintsConfig() {
        homeFormationLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        awayFormationLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(homeFormationLabel.snp.trailing)
        }
    }
    
    func configure(with matchDetailData: MatchDetailRealmData) {
        homeFormationLabel.text = matchDetailData.homeFormation
        awayFormationLabel.text = matchDetailData.awayFormation
    }
}

extension FormationSectionFooterView {
    private final class FormationFooterLabel: UILabel {
        convenience init() {
            self.init(frame: .zero)
            viewConfig()
        }
        
        private func viewConfig() {
            textColor = .white
            textAlignment = .center
            font = .systemFont(ofSize: 18, weight: .semibold)
        }
    }
}
