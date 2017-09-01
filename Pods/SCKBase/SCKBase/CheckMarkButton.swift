//
//  CheckMarkButton.swift
//  Checkout
//
//  Created by Jean-Louis Murphy on 2017-01-25.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit

open class CheckMarkButton : UIButton, CAAnimationDelegate {
    
    
    open var width : CGFloat = 8
    
    open var pathLayer = CAShapeLayer()
    open var checkColor : UIColor = colors.greenColor
    private var checked : Bool = false
    
    open var isChecked : Bool {
        get {
            return checked
        }
    }
    private var checkMarkKVOberver = String()
    
    open var setCheckObserver : String {
        get {
            return ""
        } set {
            checkMarkKVOberver = newValue
        }
    }
    
    open var ckeckValue : String {
        get {
            return "CheckMarkButtonChecked\(checkMarkKVOberver)"
        }
    }
    open var uncheckValue : String {
        get {
            return "CheckMarkButtonUnChecked\(checkMarkKVOberver)"
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        layer.borderWidth = 2.5
        layer.borderColor = UIColor.white.cgColor
        layer.masksToBounds = true
        
        let path = UIBezierPath()
        let cont = CGRect(x: frame.width * 0.15, y: frame.width * 0.15, width: frame.width * 0.7, height: frame.height * 0.7)
        path.move(to: CGPoint(x: cont.width * 0.05, y: cont.height * 0.5))
        path.addLine(to: CGPoint(x: cont.width * 0.35, y: cont.height))
        path.addLine(to: CGPoint(x: cont.width * 0.95, y: 0))
        pathLayer.frame = cont
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = checkColor.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = layer.borderWidth
        pathLayer.lineJoin = kCALineJoinRound
        pathLayer.lineCap = kCALineCapRound
        addTarget(self, action: #selector(animateTo), for: UIControlEvents.touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func with(_ color: UIColor) {
        checkColor = color
        pathLayer.strokeColor = color.cgColor
        self.layer.borderColor = color.cgColor
    }
    
    public func animateTo() {
        backgroundColor = UIColor.clear
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 0.4
        pathAnimation.fromValue = NSNumber(floatLiteral: 0)
        pathAnimation.toValue = NSNumber(floatLiteral: 1)
        
        layer.addSublayer(self.pathLayer)
        pathLayer.strokeEnd = 1.0
        pathLayer.removeAllAnimations()
        pathLayer.add(pathAnimation, forKey: "strokeEnd")
        checked = true
        
        self.removeTarget(self, action: #selector(self.animateTo), for: UIControlEvents.touchUpInside)
        self.addTarget(self, action: #selector(self.unAnimate), for: UIControlEvents.touchUpInside)
        NotificationCenter.default.post(name: NSNotification.Name.init("CheckMarkButtonChecked\(checkMarkKVOberver)"), object: nil)
        
    }
    
    public func unAnimate() {
        let reverseAnimation = CABasicAnimation(keyPath: "strokeEnd")
        reverseAnimation.duration = 0.4
        reverseAnimation.fromValue = NSNumber(floatLiteral: 1)
        reverseAnimation.toValue = NSNumber(floatLiteral: 0)
        reverseAnimation.delegate = self
        
        layer.addSublayer(self.pathLayer)
        self.pathLayer.strokeEnd = 0.0
        self.pathLayer.removeAllAnimations()
        self.pathLayer.add(reverseAnimation, forKey: "strokeEnd")
        checked = false
        self.removeTarget(self, action: #selector(self.unAnimate), for: UIControlEvents.touchUpInside)
        self.addTarget(self, action: #selector(self.animateTo), for: UIControlEvents.touchUpInside)
        NotificationCenter.default.post(name: NSNotification.Name.init("CheckMarkButtonUnChecked\(checkMarkKVOberver)"), object: nil)

    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        pathLayer.removeFromSuperlayer()
    }

}
