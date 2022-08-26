//
//  FormationTableViewCell+Ext.swift
//  SoccerInfo
//
//  Created by 조동현 on 2022/08/24.
//

import UIKit

extension FormationTableViewCell {
    final class PlayerView: UIView {
        private let playerNumberLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 10)
            return label
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
            isHidden = true
            addSubview(playerNumberLabel)
        }
        
        private func constraintsConfig() {
            playerNumberLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.lessThanOrEqualTo(20)
                make.height.equalTo(playerNumberLabel.snp.width)
                make.leading.trailing.equalToSuperview().priority(999)
            }
        }
    }
    
    final class FormationVerticalStackView: UIStackView {
        convenience init() {
            self.init(frame: .zero)
            spacing = 10
            axis = .vertical
            distribution = .fillEqually
            alignment = .fill
            isHidden = true
            addArrangedSubview(PlayerView())
            addArrangedSubview(PlayerView())
            addArrangedSubview(PlayerView())
            addArrangedSubview(PlayerView())
            addArrangedSubview(PlayerView())
        }
    }
    
    final class FormationStackView: UIStackView {
        convenience init() {
            self.init(frame: .zero)
            spacing = 10
            axis = .horizontal
            distribution = .fillEqually
            addArrangedSubview(FormationVerticalStackView())
            addArrangedSubview(FormationVerticalStackView())
            addArrangedSubview(FormationVerticalStackView())
            addArrangedSubview(FormationVerticalStackView())
            addArrangedSubview(FormationVerticalStackView())
        }
    }
}
