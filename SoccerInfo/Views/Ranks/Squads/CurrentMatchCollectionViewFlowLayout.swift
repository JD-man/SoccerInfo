//
//  CurrentMatchCollectionViewFlowLayout.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/12/12.
//

import UIKit

class CurrentMatchCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        
        // height = collection view height constant - 20
        let height: CGFloat = 130
        // width = screen width * 0.8
        let width: CGFloat = UIScreen.main.bounds.width * 0.7
        
        let inset: CGFloat = 10
        sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
        scrollDirection = .horizontal
        itemSize = CGSize(width: width, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
