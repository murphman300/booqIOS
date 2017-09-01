//
//  UIView+Helpers.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-23.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

extension UIView {
    
    func addBorder(_ side: viewSides, _ color: UIColor) {
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
            y = frame.height - 1
            width = frame.width
            height = 1
            
        }
        let botBorder = View()
        botBorder.frame = CGRect(x: x, y: y, width: width, height: height)
        botBorder.backgroundColor = color
        addSubview(botBorder)
    }
    
    func contrastBackgroundForConstraints(startFrom: ContrastSide, fadeFrom: UIColor, toColor: UIColor, fadeAt: [Double], h: CGFloat, w: CGFloat) {
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
    
}
