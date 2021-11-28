//
//  UIView+Extension.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/28.
//
import UIKit

extension UIView {
    func addShadow(color: UIColor = UIColor.black, rad: CGFloat = 10,
                   opacity: Float = 0.15, offset: CGSize = .zero) {
        self.clipsToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = rad
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
    }
    
    func addCorner() {
        self.clipsToBounds = false
        self.layer.cornerRadius = 15
    }
}
