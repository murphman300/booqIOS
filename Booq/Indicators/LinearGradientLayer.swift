//
//  LinearGradientLayer.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-29.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//


import UIKit

class GradientCircleLoader: UIView, CAAnimationDelegate {
    
    private var colors = ColorGradient()
    
    private var lineWidth : CGFloat = 1
    
    private var loaderLayer = CAShapeLayer()
    
    private var loaderGradient = CAGradientLayer()
    
    private var loaderPath = UIBezierPath()
    
    private var percentage = Percentage()
    
    private var con = UIGraphicsGetCurrentContext()
    
    private let pi = Double.pi
    
    private var animationTime : Double = 1.0
    
    var percent : CGFloat {
        get {
            return percentage.percent.cgFloat
        } set {
            setLoadTo(newValue)
        }
    }
    
    init(frame: CGRect, gradient: ColorGradient) {
        super.init(frame: frame)
        self.colors = gradient
        set()
    }
    
    func set() {
        let this = self.frame
        
        let startAngle = (Double.pi / 2).cgFloat
        let endAngle = CGFloat((Double.pi * 2).cgFloat + startAngle)
        let centerPoint = CGPoint(x: frame.width / 2 , y: frame.height / 2)
        
        let centerP = CGPoint(x: this.width / 2, y: this.height / 2)
        let final = Percentage().mod(1.0)
        let angles = final.cgStartAndEndAngles
        let gradientMask = applyGradientProperties()
        loaderPath = UIBezierPath(arcCenter: centerP, radius: (this.height-10) / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        loaderLayer.path = loaderPath.cgPath
        loaderLayer.backgroundColor = UIColor.clear.cgColor
        loaderLayer.strokeColor = UIColor.black.cgColor
        loaderLayer.fillColor = nil
        loaderLayer.strokeStart = 0
        loaderLayer.strokeEnd = 0
        loaderLayer.lineWidth = 10
        loaderLayer.lineCap = kCALineCapRound
        
        gradientMask.mask = loaderLayer
        layer.addSublayer(gradientMask)
        
    }
    
    private func applyGradientProperties() ->CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width:  self.frame.width, height:  self.frame.height)
        gradient.locations = [0.0, 1.0]
        gradient.colors = colors.onlyColors
        return gradient
    }
    
    private func setLoadTo(_ percent: CGFloat) {
        percentage.modify(percent.double)
    }
    
    private func animateLoadTo(_ percent: CGFloat) {
        setLoadTo(percent)
        let anim3 = CABasicAnimation(keyPath: "strokeEnd")
        anim3.duration = animationTime
        anim3.fromValue = 0
        anim3.toValue = 1.0
        anim3.isRemovedOnCompletion = false
        anim3.isAdditive = true
        anim3.fillMode = kCAFillModeForwards
        anim3.delegate = self
        self.loaderLayer.add(anim3, forKey: "strokeEnd")
    }
    
    private func animateLoadTo(_ percent: CGFloat,_ completion: (()->())?) {
        setLoadTo(percent)
        completion?()
    }
    
    func setLoadTo(_ percent: CGFloat,_ animated: Bool) {
        if animated {
            animateLoadTo(percent)
        } else {
            setLoadTo(percent)
        }
    }
    
    func setLoadTo(_ percent: CGFloat,_ animated: Bool,_ completion: (()->())?) {
        if animated {
            animateLoadTo(percent, completion)
        } else {
            setLoadTo(percent)
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("Stoped")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
