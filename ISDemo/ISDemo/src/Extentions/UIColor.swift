//
//  UIColor.swift
//  ISDemo
//
//  Created by Utsav Patel on 3/27/19.
//  Copyright © 2019 erbittuu. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
    }
    class var green: UIColor { return UIColor(red: 76, green: 217, blue: 100) }
    class var blue: UIColor { return UIColor(red: 0, green: 122, blue: 255) }
}
