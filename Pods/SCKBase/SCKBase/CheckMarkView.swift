//
//  CheckMarkView.swift
//  CellTester
//
//  Created by Jean-Louis Murphy on 2016-12-09.
//  Copyright © 2016 Jean-Louis Murphy. All rights reserved.
//

import UIKit
import CoreGraphics
import AudioToolbox

open class CheckMarkView: UIView, CAAnimationDelegate {
    
    var width : CGFloat = 8
    
    var pathLayer = CAShapeLayer()
    var checkColor : UIColor = checkColors.signupGreen
    var vibrates : Bool = false
    
    private var time : Double = 0.5
    var animateOverTime : Double {
        get {
            return time
        } set {
            time = newValue
        }
    }
    
    //var animateTime :
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience public init(frame: CGRect, strokeWidth: CGFloat?) {
        self.init(frame: frame)
        width = frame.width * 0.05
        if strokeWidth != nil {
            width = strokeWidth!
        }
        alpha = 0
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = width
        layer.masksToBounds = true
        
        let innerR = frame.width * 0.8
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.width * 0.15, y: frame.height * 0.53))
        path.addLine(to: CGPoint(x: CGFloat(frame.width * 0.1) + (innerR * 0.3), y: (frame.height / 2) + ((innerR / 2) * 0.82)))
        path.addLine(to: CGPoint(x: frame.width * 0.79, y: frame.height * 0.27))
        pathLayer.frame = bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = checkColor.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = width
        pathLayer.lineJoin = kCALineJoinBevel
        pathLayer.lineCap = kCALineCapRound
        
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func with(_ color: UIColor) {
        checkColor = color
        pathLayer.strokeColor = checkColor.cgColor
        self.layer.borderColor = checkColor.cgColor
    }
    
    public func animate(_ completion: @escaping (Bool) -> Void) {
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = time
        pathAnimation.fromValue = NSNumber(floatLiteral: 0)
        pathAnimation.toValue = NSNumber(floatLiteral: 1)
        
        layer.addSublayer(self.pathLayer)
        pathLayer.strokeEnd = 1.0
        pathLayer.removeAllAnimations()
        pathLayer.add(pathAnimation, forKey: "strokeEnd")
        
        UIView.animate(withDuration: time / 2, animations: {
            
            self.layer.borderColor = self.checkColor.cgColor
            self.layer.masksToBounds = true
            self.alpha = 1
            
        }, completion: {
            (value:Bool) in
            completion(true)
            if self.vibrates {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        })
        
    }
    
    public func reverse(_ completion: @escaping (Bool) -> Void) {
        
        let reverseAnimation = CABasicAnimation(keyPath: "strokeEnd")
        reverseAnimation.duration = time
        reverseAnimation.fromValue = NSNumber(floatLiteral: 1)
        reverseAnimation.toValue = NSNumber(floatLiteral: 0)
        reverseAnimation.delegate = self
        
        layer.addSublayer(self.pathLayer)
        self.pathLayer.strokeEnd = 0.0
        self.pathLayer.removeAllAnimations()
        self.pathLayer.add(reverseAnimation, forKey: "strokeEnd")
        
        UIView.animate(withDuration: time, animations: {
            
            self.layer.borderColor = UIColor.clear.cgColor
            self.layer.masksToBounds = true
            self.alpha = 0
            
        }, completion: {
            (value:Bool) in
            completion(true)
        })
        
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        pathLayer.removeFromSuperlayer()
    }
}
