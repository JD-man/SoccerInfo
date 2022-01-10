//
//  UITableViewCell+Extension.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2022/01/10.
//
import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
