//
//  ProgressView.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-29.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit

class ProgressView: UIView, CAAnimationDelegate {
    
    private let progressLayer: CAShapeLayer = CAShapeLayer()
    
    private var progressLabel: UILabel
    
    private var gradient : CAGradientLayer?
    
    required init?(coder aDecoder: NSCoder) {
        progressLabel = UILabel()
        super.init(coder: aDecoder)
        createProgressLayer()
    }
    
    override init(frame: CGRect) {
        progressLabel = UILabel()
        super.init(frame: frame)
        createProgressLayer()
    }
    
    private func createProgressLayer() {
        print(frame)
        let startAngle = (Double.pi / 2).cgFloat
        let endAngle = CGFloat((Double.pi * 2).cgFloat + startAngle)
        let centerPoint = CGPoint(x: frame.width / 2 , y: frame.height / 2)
        
        gradient = gradientMask()
        progressLayer.path = UIBezierPath(arcCenter:centerPoint, radius: (frame.width / 2) - 30.0, startAngle:startAngle, endAngle:endAngle, clockwise: true).cgPath
        progressLayer.backgroundColor = UIColor.clear.cgColor
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.black.cgColor
        progressLayer.lineWidth = 4.0
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        
        gradient?.mask = progressLayer
        layer.addSublayer(gradient!)
    }
    
    private func gradientMask() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.locations = [0.0, 1.0]
        
        let colorTop: AnyObject = UIColor(red: 255.0/255.0, green: 213.0/255.0, blue: 63.0/255.0, alpha: 1.0).cgColor
        let colorBottom: AnyObject = UIColor(red: 255.0/255.0, green: 198.0/255.0, blue: 5.0/255.0, alpha: 1.0).cgColor
        let arrayOfColors: [AnyObject] = [colorTop, colorBottom]
        gradientLayer.colors = arrayOfColors
        
        return gradientLayer
    }
    
    func hideProgressView() {
        progressLayer.strokeEnd = 0.0
        progressLayer.removeAllAnimations()
        progressLabel.text = "Load content"
    }
    
    func animateProgressView() {
        progressLabel.text = "Loading..."
        progressLayer.strokeEnd = 0.0
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(0.0)
        animation.toValue = CGFloat(1.0)
        animation.duration = 1.0
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = kCAFillModeForwards
        animation.delegate = self
        progressLayer.add(animation, forKey: "strokeEnd")
        if let g = gradient {
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("Stoped")
    }
}

