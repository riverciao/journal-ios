//
//  UIColor.swift
//  journal-ios
//
//  Created by riverciao on 2017/12/8.
//  Copyright © 2017年 riverciao. All rights reserved.
//


import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
