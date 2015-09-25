//
//  UIView.swift
//  Portfolio
//
//  Created by Michael Shafer on 25/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import UIKit

// Usage: insert view.fadeTransition right before changing content
extension UIView {
    func fadeTransition(duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        self.layer.addAnimation(animation, forKey: kCATransitionFade)
    }
}