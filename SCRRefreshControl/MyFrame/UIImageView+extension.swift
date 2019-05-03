//
//  UIImageView+extension.swift
//  SCRefreshControl
//
//  Created by Stephen Cao on 3/5/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

extension UIImageView{
    func rotateVertically(angle:Double = Double.pi,reset: Bool){
        UIView.animate(withDuration: 0.25) {
            if reset{
                self.transform = CGAffineTransform.identity
                return
            }
            self.transform = CGAffineTransform(
                rotationAngle: CGFloat(angle - Double.pi / 1800))
        }
    }
}
