//
//  UIColor+Extension.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/12/22.
//

import UIKit

extension UIColor {
    static func rgbColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
