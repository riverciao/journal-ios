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

extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 0.5, y: 0.5)
        
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension UIImageView {
    func addGradientEffect(frame: CGRect, colors: [UIColor]) {
        let gradientLayer = CAGradientLayer(frame: frame, colors: colors)
        self.layer.addSublayer(gradientLayer)
    }
}


