//
//  UIView+Helpers.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit



public extension UIView {
    
    public func gradientBorder(_ withColors : [UIColor],_ inDirection: ContrastSides,_ withGradientLayout: [CGFloat], _ withRadius: CGFloat?) {
        var radius = CGFloat()
        if let rad = withRadius {
            radius = rad
        } else {
            radius = frame.height / 2
        }
        guard withColors.count > 0 else {
            return
        }
        layer.cornerRadius = radius
        layer.masksToBounds = true
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: .zero, size: self.frame.size)
        var cgColors = [CGColor]()
        if withColors.count == 1 {
            cgColors.append(withColors[0].cgColor)
            cgColors.append(withColors[0].withAlphaComponent(0).cgColor)
        } else if withColors.count > 1 {
            for color in withColors {
                cgColors.append(color.cgColor)
            }
        }
        var sX = CGFloat()
        var sY = CGFloat()
        var eX = CGFloat()
        var eY = CGFloat()
        switch inDirection {
        case .left:
            sX = 1.0
            sY = 0.5
            eX = 0.0
            eY = 0.5
        case .right:
            sX = 0.0
            sY = 0.5
            eX = 1.0
            eY = 0.5
        case .top:
            sX = 0.5
            sY = 1.0
            eX = 0.5
            eY = 0
        case .bottom:
            sX = 0.5
            sY = 0
            eX = 0.5
            eY = 1
        case .bottomLeft:
            sX = 1.0
            sY = 0.0
            eX = 0.0
            eY = 1.0
        case .bottomRight:
            sX = 0.0
            sY = 0.0
            eX = 1.0
            eY = 1.0
        case .topLeft:
            sX = 1.0
            sY = 1.0
            eX = 0.0
            eY = 0.0
        case .topRight:
            sX = 0.0
            sY = 1.0
            eX = 1.0
            eY = 0.0
        }
        gradient.colors = cgColors
        gradient.startPoint = CGPoint(x: sX, y: sY)
        gradient.endPoint = CGPoint(x: eX, y: eY)
        if withColors.count == 1 || withColors.count == 0 {
            gradient.locations = [0.8, 0.99] as [NSNumber]?
        } else if withColors.count > 1 {
            var db = [CGFloat]()
            let part : CGFloat = 1 * (1 / CGFloat(withColors.count - 1))
            while db.count < (withColors.count) {
                if db.isEmpty {
                    db.append(0.0)
                } else if db.count == withColors.count {
                    db.append(1.0)
                } else {
                    let num = part * CGFloat(db.count)
                    db.append(num)
                }
            }
            gradient.locations = db as [NSNumber]?
        }
        gradient.locations = withGradientLayout as [NSNumber]?
        gradient.backgroundColor = UIColor.clear.cgColor
        let shape = CAShapeLayer()
        shape.lineWidth = 6
        shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        layer.addSublayer(gradient)
    }
    
    func contrastBackGroundForViewWithConstraints(_ startFrom: contrastSides,_ fadeFrom: UIColor,_ toColor: UIColor,_ fadeAt: [CGFloat],_ h: CGFloat,_ w: CGFloat) {
        var x = CGFloat()
        var y = CGFloat()
        var width = CGFloat()
        var height = CGFloat()
        var sX = CGFloat()
        var sY = CGFloat()
        var eX = CGFloat()
        var eY = CGFloat()
        x = 0
        y = 0
        width = w
        height = h
        switch startFrom {
        case .left:
            sX = 0.0
            sY = 0.5
            eX = 1
            eY = 0.5
        case .right:
            sX = 1
            sY = 0.5
            eX = 0.0
            eY = 0.5
        case .top:
            sX = 0.5
            sY = 0
            eX = 0.5
            eY = 1
        case .bottom:
            sX = 0.5
            sY = 1.0
            eX = 0.5
            eY = 0
        case .bottomLeft:
            sX = 0.0
            sY = 1.0
            eX = 1.0
            eY = 0.0
        case .bottomRight:
            sX = 1.0
            sY = 1.0
            eX = 0.0
            eY = 0.0
        case .topLeft:
            sX = 0.0
            sY = 0.0
            eX = 1.0
            eY = 1.0
        case .topRight:
            sX = 1.0
            sY = 0.0
            eX = 0.0
            eY = 1.0
            
        }
        let shadowBorder = CAGradientLayer()
        shadowBorder.frame = CGRect(x: x, y: y, width: width, height: height)
        let color1 = fadeFrom.cgColor as CGColor
        let color2 = toColor.cgColor as CGColor
        shadowBorder.colors = [color1, color2]
        shadowBorder.startPoint = CGPoint(x: sX, y: sY)
        shadowBorder.endPoint = CGPoint(x: eX, y: eY)
        shadowBorder.locations = fadeAt as [NSNumber]?
        layer.insertSublayer(shadowBorder, at: 0)
    }
    
    func addSolidBorderView(_ side: viewSides, _ color: UIColor){
        var x = CGFloat()
        var y = CGFloat()
        var width = CGFloat()
        var height = CGFloat()
        switch side {
        case .left:
            x = 0
            y = 0
            width = 0.5
            height = frame.height
            
        case .right:
            x = frame.width
            y = 0
            width = 0.5
            height = frame.height
            
        case .top:
            x = 0
            y = 0
            width = frame.width
            height = 0.5
            
        case .bottom:
            x = 0
            y = frame.height - 0.5
            width = frame.width
            height = 0.5
            
        }
        let botBorder = UIView()
        botBorder.frame = CGRect(x: x, y: y, width: width, height: height)
        botBorder.backgroundColor = color
        addSubview(botBorder)
    }
    func addSolidBorder(_ toSide: viewSides, _ color: UIColor,_ ofWidth: CGFloat){
        var x = CGFloat()
        var y = CGFloat()
        var width = CGFloat()
        var height = CGFloat()
        let value : CGFloat = ofWidth
        switch toSide {
        case .top:
            x = 0
            y = 0
            width = frame.width
            height = value
            
        case .bottom:
            x = 0
            y = frame.height - value
            width = frame.width
            height = value
        default:
            break
            
        }
        let botBorder = CALayer()
        botBorder.frame = CGRect(x: x, y: y, width: width, height: height)
        botBorder.backgroundColor = color.cgColor
    }
    
    public func rotate(_ dur: CFTimeInterval,_ completion: CAAnimationDelegate?) {
        let rotateAnim = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnim.fromValue = 0.0
        rotateAnim.toValue = CGFloat(Double.pi)
        rotateAnim.duration = dur
        if let del = completion {
            rotateAnim.delegate = del
        }
        self.layer.add(rotateAnim, forKey: nil)
    }
    
    public func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    public func roundCorners(_ corner: UIRectCorner,_ radii: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.layer.bounds
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radii, height: radii)).cgPath
        
        self.layer.mask = maskLayer
        layer.masksToBounds = true
    }
    
    public func ovalView(_ mult: CGFloat) {
        layer.cornerRadius = mult * (self.frame.height * 2)
        layer.masksToBounds = true
    }
    
    public func clearViu() {
        if let window = UIApplication.shared.keyWindow {
            frame = CGRect(x: 0, y: 0, width: (window.frame.width), height: (window.frame.height))
            alpha = 0
            backgroundColor = colors.clearViu
            
        }
    }
    
    public func sideCircleView(_ value: CGFloat?) {
        
        if let radius = value {
            
            layer.cornerRadius = radius//0.5 * frame.height
            layer.masksToBounds = true
        } else {
            
            layer.cornerRadius = 0.5 * frame.height
            layer.masksToBounds = true
        }
        
    }
    
    public func sideCircleViewWithConstraints(_ height: CGFloat?) {
        
        if let radius = height {
            
            layer.cornerRadius = radius * 0.5
            layer.masksToBounds = true
        } else {
            
            layer.cornerRadius = 0.5 * frame.height
            layer.masksToBounds = true
        }
        
    }
    
    public func backgroundWith(_ contrasts: [ContrastBackground]) {
        var ind : Int = 0
        for contrast in contrasts {
            contrastBackGround((contrast.side?.toContrast())!, contrast.fadeFrom, contrast.toColor, contrast.fadeAt, ind)
            ind += 1
        }
    }
    
    public func contrastBackGround(_ startFrom: contrastSides,_ fadeFrom: UIColor,_ toColor: UIColor,_ fadeAt: [CGFloat],_ atIndex: Int) {
        var x = CGFloat()
        var y = CGFloat()
        var width = CGFloat()
        var height = CGFloat()
        var sX = CGFloat()
        var sY = CGFloat()
        var eX = CGFloat()
        var eY = CGFloat()
        x = 0
        y = 0
        width = frame.width
        height = frame.height
        switch startFrom {
        case .left:
            sX = 1.0
            sY = 0.5
            eX = 0
            eY = 0.5
        case .right:
            sX = 0
            sY = 0.5
            eX = 1.0
            eY = 0.5
        case .top:
            sX = 0.5
            sY = 0.0
            eX = 0.5
            eY = 1.0
        case .bottom:
            sX = 0.5
            sY = 1.0
            eX = 0.5
            eY = 0.0
        case .bottomLeft:
            sX = 0.0
            sY = 1.0
            eX = 1.0
            eY = 0.0
        case .bottomRight:
            sX = 1.0
            sY = 1.0
            eX = 0.0
            eY = 0.0
        case .topLeft:
            sX = 0.0
            sY = 0.0
            eX = 1.0
            eY = 1.0
        case .topRight:
            sX = 1.0
            sY = 0.0
            eX = 0.0
            eY = 1.0
            
        }
        let shadowBorder = CAGradientLayer()
        shadowBorder.frame = CGRect(x: x, y: y, width: width, height: height)
        let color1 = fadeFrom.cgColor as CGColor
        let color2 = toColor.cgColor as CGColor
        shadowBorder.colors = [color1, color2]
        shadowBorder.startPoint = CGPoint(x: sX, y: sY)
        shadowBorder.endPoint = CGPoint(x: eX, y: eY)
        shadowBorder.locations = fadeAt as [NSNumber]?
        layer.insertSublayer(shadowBorder, at: UInt32(atIndex))
        
    }
    
    public func contrastBackGround(_ startFrom: contrastSides,_ fadeFrom: UIColor,_ toColor: UIColor,_ fadeAt: [CGFloat]) {
        var x = CGFloat()
        var y = CGFloat()
        var width = CGFloat()
        var height = CGFloat()
        var sX = CGFloat()
        var sY = CGFloat()
        var eX = CGFloat()
        var eY = CGFloat()
        x = 0
        y = 0
        width = frame.width
        height = frame.height
        switch startFrom {
        case .left:
            sX = 1.0
            sY = 0.5
            eX = 0
            eY = 0.5
        case .right:
            sX = 0
            sY = 0.5
            eX = 1.0
            eY = 0.5
        case .top:
            sX = 0.5
            sY = 0.0
            eX = 0.5
            eY = 1.0
        case .bottom:
            sX = 0.5
            sY = 1.0
            eX = 0.5
            eY = 0.0
        case .bottomLeft:
            sX = 0.0
            sY = 1.0
            eX = 1.0
            eY = 0.0
        case .bottomRight:
            sX = 1.0
            sY = 1.0
            eX = 0.0
            eY = 0.0
        case .topLeft:
            sX = 0.0
            sY = 0.0
            eX = 1.0
            eY = 1.0
        case .topRight:
            sX = 1.0
            sY = 0.0
            eX = 0.0
            eY = 1.0
            
        }
        let shadowBorder = CAGradientLayer()
        shadowBorder.frame = CGRect(x: x, y: y, width: width, height: height)
        let color1 = fadeFrom.cgColor as CGColor
        let color2 = toColor.cgColor as CGColor
        shadowBorder.colors = [color1, color2]
        shadowBorder.startPoint = CGPoint(x: sX, y: sY)
        shadowBorder.endPoint = CGPoint(x: eX, y: eY)
        shadowBorder.locations = fadeAt as [NSNumber]?
        layer.insertSublayer(shadowBorder, at: 0)
    }
    
    public func contrastBackGroundForViewWithConstraints(_ startFrom: ContrastSides,_ fadeFrom: UIColor,_ toColor: UIColor,_ fadeAt: [CGFloat],_ h: CGFloat,_ w: CGFloat) {
        var x = CGFloat()
        var y = CGFloat()
        var width = CGFloat()
        var height = CGFloat()
        var sX = CGFloat()
        var sY = CGFloat()
        var eX = CGFloat()
        var eY = CGFloat()
        x = 0
        y = 0
        width = w
        height = h
        switch startFrom {
        case .left:
            sX = 0.0
            sY = 0.5
            eX = 1
            eY = 0.5
        case .right:
            sX = 1
            sY = 0.5
            eX = 0.0
            eY = 0.5
        case .top:
            sX = 0.5
            sY = 0
            eX = 0.5
            eY = 1
        case .bottom:
            sX = 0.5
            sY = 1.0
            eX = 0.5
            eY = 0
        case .bottomLeft:
            sX = 0.0
            sY = 1.0
            eX = 1.0
            eY = 0.0
        case .bottomRight:
            sX = 1.0
            sY = 1.0
            eX = 0.0
            eY = 0.0
        case .topLeft:
            sX = 0.0
            sY = 0.0
            eX = 1.0
            eY = 1.0
        case .topRight:
            sX = 1.0
            sY = 0.0
            eX = 0.0
            eY = 1.0
            
        }
        let shadowBorder = CAGradientLayer()
        shadowBorder.frame = CGRect(x: x, y: y, width: width, height: height)
        let color1 = fadeFrom.cgColor as CGColor
        let color2 = toColor.cgColor as CGColor
        shadowBorder.colors = [color1, color2]
        shadowBorder.startPoint = CGPoint(x: sX, y: sY)
        shadowBorder.endPoint = CGPoint(x: eX, y: eY)
        shadowBorder.locations = fadeAt as [NSNumber]?
        layer.insertSublayer(shadowBorder, at: 0)
    }
    
    public func addShadow(_ side: viewSides) {
        var x = CGFloat()
        var y = CGFloat()
        var width = CGFloat()
        var height = CGFloat()
        var sX = CGFloat()
        var sY = CGFloat()
        var eX = CGFloat()
        var eY = CGFloat()
        switch side {
        case .left:
            x = -5
            y = 0
            width = 5
            height = frame.height
            sX = 1.0
            sY = 0.5
            eX = 0
            eY = 0.5
        case .right:
            x = frame.width
            y = 0
            width = 5
            height = frame.height
            sX = 0
            sY = 0.5
            eX = 1.0
            eY = 0.5
        case .top:
            x = 0
            y = -5
            width = frame.width
            height = 5
            sX = 0.5
            sY = 1.0
            eX = 0.5
            eY = 0.0
        case .bottom:
            x = 0
            y = frame.height
            width = frame.width
            height = 5
            sX = 0.5
            sY = 0.0
            eX = 0.5
            eY = 1.0
        }
        let shadowBorder = CAGradientLayer()
        shadowBorder.frame = CGRect(x: x, y: y, width: width, height: height)
        let color1 = UIColor.black.withAlphaComponent(0.4).cgColor as CGColor
        let color2 = UIColor.clear.cgColor as CGColor
        shadowBorder.colors = [color1, color2]
        shadowBorder.startPoint = CGPoint(x: sX, y: sY)
        shadowBorder.endPoint = CGPoint(x: eX, y: eY)
        shadowBorder.locations = [0, 0.3]
        layer.addSublayer(shadowBorder)
    }
    
    public func addSolidBorder(_ side: viewSides, _ color: UIColor){
        var x = CGFloat()
        var y = CGFloat()
        var width = CGFloat()
        var height = CGFloat()
        switch side {
        case .left:
            x = 0
            y = 0
            width = 0.5
            height = frame.height
            
        case .right:
            x = frame.width
            y = 0
            width = 0.5
            height = frame.height
            
        case .top:
            x = 0
            y = 0
            width = frame.width
            height = 0.5
            
        case .bottom:
            x = 0
            y = frame.height - 0.5
            width = frame.width
            height = 0.5
            
        }
        let botBorder = CALayer()
        botBorder.frame = CGRect(x: x, y: y, width: width, height: height)
        botBorder.backgroundColor = color.cgColor
        layer.addSublayer(botBorder)
    }
    
    public func addSolidBorderForViewWithConstraints(_ side: viewSides, _ color: UIColor,_ desiredHeight: CGFloat,_ desiredWidth: CGFloat?){
        var x = CGFloat()
        var y = CGFloat()
        var contWidth = CGFloat()
        var contHeight = CGFloat()
        var width = CGFloat()
        var height = CGFloat()
        let theWidth : CGFloat = 0.35
        if frame.width == 0 && frame.height == 0 {
            if let w = desiredWidth {
                contWidth = w
            } else {
                contWidth = screen.width
            }
            contHeight = desiredHeight
            
            switch side {
            case .left:
                x = 0
                y = 0
                width = theWidth
                height = contHeight
                
            case .right:
                x = contWidth
                y = 0
                width = theWidth
                height = contHeight
                
            case .top:
                x = 0
                y = 0
                width = contWidth
                height = desiredHeight
                
            case .bottom:
                x = 0
                y = frame.height - contHeight
                width = contWidth
                height = contHeight
                
            }
        } else {
            switch side {
            case .left:
                x = 0
                y = 0
                width = 0.5
                height = frame.height
                
            case .right:
                x = frame.width
                y = 0
                width = 0.5
                height = frame.height
                
            case .top:
                x = 0
                y = 0
                width = frame.width
                height = 0.5
                
            case .bottom:
                x = 0
                y = frame.height - 0.5
                width = frame.width
                height = 0.5
                
            }
        }
        let botBorder = CALayer()
        botBorder.frame = CGRect(x: x, y: y, width: width, height: height)
        botBorder.backgroundColor = color.cgColor
        layer.insertSublayer(botBorder, above: layer)
    }
    
    public func addSolidNavBorder(_ side: viewSides, _ color: UIColor){
        var x = CGFloat()
        var y = CGFloat()
        var width = CGFloat()
        var height = CGFloat()
        let value : CGFloat = 0.73439
        
        switch side {
        case .left:
            x = 0
            y = 0
            width = value
            height = frame.height
            
        case .right:
            x = frame.width
            y = 0
            width = value
            height = frame.height
            
        case .top:
            x = 0
            y = 0
            width = frame.width
            height = value
            
        case .bottom:
            x = 0
            y = frame.height - value
            width = frame.width
            height = value
            
        }
        
        let botBorder = CALayer()
        botBorder.frame = CGRect(x: x, y: y, width: width, height: height)
        botBorder.backgroundColor = color.cgColor
        layer.addSublayer(botBorder)
        
    }
    
    public func addSolidCellBorder(_ side: viewSides, _ color: UIColor,_ percentOfWidth: CGFloat){
        var x = CGFloat()
        var y = CGFloat()
        var width = CGFloat()
        var height = CGFloat()
        let value : CGFloat = cells.chatcellBorder
        
        switch side {
        case .top:
            x = frame.width * (1 - percentOfWidth)
            y = 0
            width = frame.width * percentOfWidth
            height = value
            
        case .bottom:
            x = frame.width * (1 - percentOfWidth)
            y = frame.height
            width = frame.width * percentOfWidth
            height = value
        default:
            break
            
        }
        
        let botBorder = CALayer()
        botBorder.frame = CGRect(x: x, y: y, width: width, height: height)
        botBorder.backgroundColor = color.cgColor
        layer.addSublayer(botBorder)
    }
    
    public func addCircleShadowToShadowContainer(_ size: CGFloat) {
        
        let shadowBorder = CAGradientLayer()
        shadowBorder.frame = CGRect(x: 0, y: 0, width: size, height: size)
        shadowBorder.cornerRadius = 0.5 * shadowBorder.bounds.size.width
        let color1 = UIColor.black.withAlphaComponent(0.3).cgColor as CGColor
        let color2 = UIColor.clear.cgColor as CGColor
        shadowBorder.colors = [color1, color2]
        shadowBorder.startPoint = CGPoint(x: 0.5, y: 1.0)
        shadowBorder.endPoint = CGPoint(x: 0.5, y: 0.0)
        shadowBorder.locations = [0, 0.5]
        layer.addSublayer(shadowBorder)
        
    }
    
    public func disapear() {
        self.alpha = 0
    }
    
}


