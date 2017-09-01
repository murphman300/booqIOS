//
//  CALayer+Helpers.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit


public extension CALayer {
    
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
        addSublayer(botBorder)
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
        addSublayer(shadowBorder)
    }
    
}
