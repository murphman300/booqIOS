//
//  CircleGradientLayer.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-29.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//
import UIKit

protocol GradientLoaderDelegate {
    func gradient(loader: LinearGradientCircleLoader, hasAppeared: Bool)
}

class LinearGradientCircleLoader: UIView, CAAnimationDelegate {
    
    var lay = LinearGradientLayer()
    
    var loadDelegate : GradientLoaderDelegate?
    
    private var hasLoaded : Bool = false
    
    var switchAnimation = CABasicAnimation(keyPath: "rotate")
    var time = Timer()
    
    required init(frame: CGRect, colors: ColorGradient) {
        super.init(frame: frame)
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let this = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        lay = LinearGradientLayer(bounds: this, position: center, colors: colors)
        lay.animationDelegate = self
        layer.addSublayer(lay)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("rotated")
        if let d = loadDelegate {
            d.gradient(loader: self, hasAppeared: flag)
        }
    }
    
    func rotate() {
        UIView.animate(withDuration: 1.0, animations: {
            //var transform = CATransform3DMakeTranslation(0, 0, 0)
            //transform = CATransform3DRotate(transform, (Double.pi * 2).cgFloat, 0.0, 0.0, 0.0)
            self.transform = CGAffineTransform(rotationAngle: (Double.pi * 2).cgFloat)
        }) { (v) in
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


