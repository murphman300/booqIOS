//
//  PinCircles.swift
//  Checkout
//
//  Created by Jean-Louis Murphy on 2017-03-27.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit

open class PinCircles: UIView {
    open var number = 4
    open var selected : UIColor?
    private var one : UIView = {
        var v = UIView()
        v.tag = 1
        return v
    }()
    
    private var two : UIView = {
        var v = UIView()
        v.tag = 2
        return v
    }()
    
    private var three : UIView = {
        var v = UIView()
        v.tag = 3
        return v
    }()
    
    private var four : UIView = {
        var v = UIView()
        v.tag = 4
        return v
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    open func set() {
        circles = [one, two, three, four]
        let width = frame.width * 0.8
        let area = width / CGFloat(circles.count)
        let half = area / 2
        for circle in circles {
            circle.frame.size = CGSize(width: area * 0.8, height: area * 0.8)
            circle.center.x = ((CGFloat(circle.tag - 1) * area) + CGFloat(half)) + (frame.width * 0.1)
            circle.center.y = frame.height / 2
            circle.backgroundColor = UIColor.clear
            circle.layer.borderColor = UIColor.white.cgColor
            circle.layer.borderWidth = 2.5
            circle.sideCircleView(nil)
            addSubview(circle)
        }
    }
    
    public func updateCircles(_ int: Int) {
        guard int <= 4 else {
            return
        }
        if selected == nil {
            selected = colors.loginTfBack
        }
        guard let sel = selected else {
            return
        }
        switch int {
        case 0 :
            one.backgroundColor = UIColor.clear
            two.backgroundColor = UIColor.clear
            three.backgroundColor = UIColor.clear
            four.backgroundColor = UIColor.clear
        case 1:
            one.backgroundColor = sel
            two.backgroundColor = UIColor.clear
            three.backgroundColor = UIColor.clear
            four.backgroundColor = UIColor.clear
        case 2:
            one.backgroundColor = sel
            two.backgroundColor = sel
            three.backgroundColor = UIColor.clear
            four.backgroundColor = UIColor.clear
        case 3:
            one.backgroundColor = sel
            two.backgroundColor = sel
            three.backgroundColor = sel
            four.backgroundColor = UIColor.clear
        case 4:
            one.backgroundColor = sel
            two.backgroundColor = sel
            three.backgroundColor = sel
            four.backgroundColor = sel
        default:
            break
        }
    }
    open var circles = [UIView]()
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
