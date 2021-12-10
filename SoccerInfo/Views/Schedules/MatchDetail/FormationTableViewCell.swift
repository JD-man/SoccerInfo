//
//  FormationTableViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/12/04.
//

import UIKit

class FormationTableViewCell: UITableViewCell {
    
    static let identifier = "FormationTableViewCell"
    
    @IBOutlet weak var homeStackView: UIStackView!
    @IBOutlet weak var awayStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(homeLineup: [LineupRealmData], awayLineup: [LineupRealmData]) {
        [(homeLineup, homeStackView! ,FormationDirection.home),
         (awayLineup, awayStackView! ,FormationDirection.away)]
            .forEach { lineup, stackView, direction in
                lineup.forEach {
                    if let grid = $0.grid {
                        let formation = direction.validateFormation(grid: grid)
                        let row = formation[0]
                        let col = formation[1]
                        let verticalStackView = stackView.subviews[col]
                        let container = verticalStackView.subviews[row]
                        if let label = container.subviews.first as? UILabel {
                            // label container view
                            container.isHidden = false
                            // vertical stack view
                            verticalStackView.isHidden = false
                            labelConfig(label: label, number: $0.number, color: direction.color)
                        }
                    }
                }
            }
    }
    
    func labelConfig(label: UILabel, number: Int, color: UIColor) {
        label.text = "\(number)"        
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10.5, weight: .medium)
        
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = color
    }
    
    enum FormationDirection {
        case home
        case away
        
        func validateFormation(grid: String) -> [Int] {
            let formation = grid.components(separatedBy: ":")
            switch self {
            case .home:
                let row = Int(formation[1])! - 1
                let col = Int(formation[0])! - 1
                return [row, col]
            case .away:
                let row = 5 - Int(formation[1])!
                let col = 5 - Int(formation[0])!
                return [row, col]
            }
        }
        
        var color: UIColor {
            switch self {
            case .home:
                return .rgbColor(r: 95, g: 65, b: 210)
            case .away:
                return .rgbColor(r: 169, g: 51, b: 58)
            }
        }
    }
}
