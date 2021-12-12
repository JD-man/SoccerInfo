//
//  SquadsViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/18.
//

import UIKit
import Kingfisher
import SwiftUI

// current 10 match results collection view -> horizontal scroll
// curretn 10 match win rate Pie Chart

// Fixtures Data -> filtering completed match by score

class SquadsViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var labelContainerView: UIView!
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var currentRankLabel: UILabel!
    @IBOutlet weak var rankDescriptionLabel: UILabel!
    
    @IBOutlet weak var currentMatchCollectionView: UICollectionView!
    
    var logoURL: String = ""
    var currentRank: Int = 0
    var teamName: String = ""
    
    private var data: [Int] = [1,2,3] {
        didSet {
            currentMatchCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
    }
    
    func viewConfig() {
        // logo imageview config
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.kf.setImage(with: URL(string: logoURL))
        
        // label container view shadow
        labelContainerView.addShadow()
        
        // labels config
        teamNameLabel.textAlignment = .center
        currentRankLabel.textAlignment = .center
        rankDescriptionLabel.textAlignment = .center
        
        teamNameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        currentRankLabel.font = .systemFont(ofSize: 19, weight: .medium)
        rankDescriptionLabel.font = .systemFont(ofSize: 15, weight: .medium)
        
        teamNameLabel.text = teamName
        currentRankLabel.text = "\(currentRank)등"
        
        // collection view config
        currentMatchCollectionView.delegate = self
        currentMatchCollectionView.dataSource = self
        currentMatchCollectionView.showsVerticalScrollIndicator = false
        currentMatchCollectionView.showsHorizontalScrollIndicator = false
        currentMatchCollectionView.collectionViewLayout = CurrentMatchCollectionViewFlowLayout()
        currentMatchCollectionView.register(UINib(nibName: "CurrentMatchCollectionViewCell", bundle: nil),
                                            forCellWithReuseIdentifier: CurrentMatchCollectionViewCell.identifier)
        
        currentMatchCollectionView.decelerationRate = .fast
        
        
    }
}

extension SquadsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentMatchCollectionViewCell.identifier, for: indexPath) as! CurrentMatchCollectionViewCell
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let flowLayout = currentMatchCollectionView.collectionViewLayout as! CurrentMatchCollectionViewFlowLayout
        
        let offset: CGFloat = flowLayout.itemSize.width
        let estimatedIndex = scrollView.contentOffset.x / offset
        var index = 0
        
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        }
        else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        }
        else {
            index = Int(round(estimatedIndex))
        }
        
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * offset, y: 0)
    }
}
