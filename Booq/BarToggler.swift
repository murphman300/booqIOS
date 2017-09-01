//
//  BarToggler.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-23.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit
import CoreGraphics

enum TogglerType {
    case bars, arrow, bottomArrow
}

class BarToggler: UIView {
    
    var top = UIBezierPath()
    var middle = UIBezierPath()
    var bottom = UIBezierPath()
    
    let padding : CGFloat = 0
    var opacity : CGFloat = 0
    
    private var topbar = CAShapeLayer()
    private var middlebar = CAShapeLayer()
    private var bottombar = CAShapeLayer()
    
    var first : CGFloat {
        get {
            return 0
        }
    }
    
    var mid : CGFloat {
        get {
            return frame.height / 2
        }
    }
    
    var third : CGFloat {
        get {
            return frame.height
        }
    }
    
    var left : CGFloat {
        get {
            return frame.width * padding
        }
    }
    
    var right : CGFloat {
        get {
            return frame.width * (1 - padding)
        }
    }
    
    var color : UIColor = .black {
        didSet {
            topbar.strokeColor = color.cgColor
            middlebar.strokeColor = color.cgColor
            bottombar.strokeColor = color.cgColor
        }
    }
    
    var thickness : CGFloat = 0 {
        didSet {
            topbar.lineWidth = thickness
            middlebar.lineWidth = thickness
            bottombar.lineWidth = thickness
        }
    }
    
    var transitionColor : UIColor?
    
    var iterimpath = UIBezierPath()
    var iterimpath2 = UIBezierPath()
    var iterimpath3 : UIBezierPath?
    
    var iterimpathSelect = UIBezierPath()
    var iterimpath2Select = UIBezierPath()
    var iterimpath3Select : UIBezierPath?
    
    var type : TogglerType? {
        didSet {
            if let t = type {
                switch t {
                case .arrow:
                    arrow()
                case .bars:
                    bars()
                case .bottomArrow:
                    bottomArrow()
                }
            }
        }
    }
    var toggled : Bool = false
    
    var toggledColor : UIColor?
    
    var animationTime : Double = 0.3
    
    var selectedAction : ((BarToggler, Bool)->())?
    var deselectedAction : ((BarToggler, Bool)->())?
    
    private var leftButStateIsMain : Bool = false
    
    private var preventCrossToggling : Bool = false
    
    func toggleState(_ to: @escaping((Bool)->Bool)) {
        leftButStateIsMain = to(leftButStateIsMain)
    }
    
    func toggleStateAndSetPreventor(_ to: @escaping((Bool)->Bool)) {
        preventCrossToggling = to(preventCrossToggling)
        toggleStateAndPerform(toggled) { (v) -> Bool in
            return self.preventCrossToggling
        }
    }
    
    func hybridToggleWith(_ selected: Bool,_ to: @escaping((Bool)->Bool)) {
        preventCrossToggling = to(preventCrossToggling)
        if selected && !preventCrossToggling {
            //Go back from search
            if toggled {
                deselect()
            } else {
                select()
            }
        } else if selected && preventCrossToggling {
            //Go to menu
            if toggled {
                deselect()
                return
            }
            leftButStateIsMain = true
            selectedAction?(self, leftButStateIsMain)
            leftButStateIsMain = false
            preventCrossToggling = false
        } else {
            if selected {
                select()
            }
        }
    }
    
    func toggleStateAndPerform(_ selected: Bool,_ to: @escaping((Bool)->Bool)) {
        guard !preventCrossToggling else { return }
        leftButStateIsMain = to(leftButStateIsMain)
        if selected {
            select()
        } else {
            deselect()
        }
    }
    
    func resetButton() {
        preventCrossToggling = false
        leftButStateIsMain = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func form() {
        
        top.move(to: CGPoint(x: left, y: first))
        top.addLine(to: CGPoint(x: right, y: first))
        
        middle.move(to: CGPoint(x: left, y: mid))
        middle.addLine(to: CGPoint(x: right, y: mid))
        
        bottom.move(to: CGPoint(x: left, y: third))
        bottom.addLine(to: CGPoint(x: right, y: third))
        
        topbar.path = top.cgPath
        topbar.lineCap = kCALineCapRound
        middlebar.path = middle.cgPath
        middlebar.lineCap = kCALineCapRound
        bottombar.path = bottom.cgPath
        bottombar.lineCap = kCALineCapRound
        
        layer.addSublayer(topbar)
        layer.addSublayer(middlebar)
        layer.addSublayer(bottombar)
        
    }
    
    
    func toggle() {
        guard !preventCrossToggling else {
            leftButStateIsMain = true
            if toggled {
                deselect()
            } else {
                select()
            }
            return
        }
        if toggled {
            deselect()
        } else {
            select()
        }
    }
    
    func deselect() {
        let anim1 = CABasicAnimation(keyPath: "path")
        anim1.duration = animationTime
        anim1.fromValue = iterimpathSelect.cgPath
        anim1.toValue = iterimpath.cgPath
        anim1.isRemovedOnCompletion = false
        anim1.fillMode = kCAFillModeBoth
        
        let anim2 = CABasicAnimation(keyPath: "path")
        anim2.duration = animationTime
        anim2.fromValue = iterimpath2Select.cgPath
        anim2.toValue = iterimpath2.cgPath
        anim2.isRemovedOnCompletion = false
        anim2.fillMode = kCAFillModeBoth
        
        
        if let sel = iterimpath3, let sel3 = iterimpath3Select {
            let anim4 = CABasicAnimation(keyPath: "path")
            anim4.duration = animationTime
            anim4.fromValue = sel3.cgPath
            anim4.toValue = sel.cgPath
            anim4.isRemovedOnCompletion = false
            anim4.fillMode = kCAFillModeBoth
            middlebar.add(anim4, forKey: "path")
        } else {
            let anim3 = CABasicAnimation(keyPath: "opacity")
            anim3.duration = animationTime
            anim3.fromValue = opacity
            anim3.toValue = 1
            anim3.isRemovedOnCompletion = false
            anim3.fillMode = kCAFillModeBoth
            
            middlebar.add(anim3, forKey: nil)
        }
        
        topbar.add(anim1, forKey: nil)
        bottombar.add(anim2, forKey: nil)
        
        UIView.animate(withDuration: animationTime, animations: {
            self.middlebar.strokeColor = self.color.cgColor
            self.bottombar.strokeColor = self.color.cgColor
            self.topbar.strokeColor = self.color.cgColor
        })
        
        deselectedAction?(self, leftButStateIsMain)
        toggled = !toggled
        if preventCrossToggling {
            preventCrossToggling = false
        }
    }
    
    func select() {
        
        let anim1 = CABasicAnimation(keyPath: "path")
        anim1.duration = animationTime
        anim1.fromValue = iterimpath
        anim1.toValue = iterimpathSelect.cgPath
        anim1.isRemovedOnCompletion = false
        anim1.fillMode = kCAFillModeBoth
        
        let anim2 = CABasicAnimation(keyPath: "path")
        anim2.duration = animationTime
        anim2.fromValue = iterimpath2.cgPath
        anim2.toValue = iterimpath2Select.cgPath
        anim2.isRemovedOnCompletion = false
        anim2.fillMode = kCAFillModeBoth
        
        if let sel = iterimpath3, let sel3 = iterimpath3Select {
            let anim4 = CABasicAnimation(keyPath: "path")
            anim4.duration = animationTime
            anim4.fromValue = sel.cgPath
            anim4.toValue = sel3.cgPath
            anim4.isRemovedOnCompletion = false
            anim4.fillMode = kCAFillModeBoth
            middlebar.add(anim4, forKey: "path")
        } else {
            let anim3 = CABasicAnimation(keyPath: "opacity")
            anim3.duration = animationTime
            anim3.fromValue = 1
            anim3.toValue = opacity
            anim3.isRemovedOnCompletion = false
            anim3.fillMode = kCAFillModeBoth
            
            middlebar.add(anim3, forKey: nil)
        }
        
        topbar.add(anim1, forKey: nil)
        bottombar.add(anim2, forKey: nil)
        if let t = toggledColor {
            UIView.animate(withDuration: animationTime, animations: {
                self.middlebar.strokeColor = t.cgColor
                self.topbar.strokeColor = t.cgColor
                self.bottombar.strokeColor = t.cgColor
            })
        }
        selectedAction?(self, leftButStateIsMain)
        toggled = !toggled
        if leftButStateIsMain {
            toggled = false
            self.leftButStateIsMain = !self.leftButStateIsMain
            preventCrossToggling = false
        }
    }
    
    func bars() {
        iterimpathSelect = UIBezierPath()
        iterimpathSelect.move(to: CGPoint(x: left, y: third))
        iterimpathSelect.addLine(to: CGPoint(x: right, y: first))
        
        iterimpath2Select = UIBezierPath()
        iterimpath2Select.move(to: CGPoint(x: left, y: first))
        iterimpath2Select.addLine(to: CGPoint(x: right, y: third))
        
        iterimpath = UIBezierPath()
        iterimpath.move(to: CGPoint(x: left, y: first))
        iterimpath.addLine(to: CGPoint(x: right, y: first))
        
        iterimpath2 = UIBezierPath()
        iterimpath2.move(to: CGPoint(x: left, y: third))
        iterimpath2.addLine(to: CGPoint(x: right, y: third))
        
    }
    
    func arrow() {
        iterimpathSelect = UIBezierPath()
        iterimpathSelect.move(to: CGPoint(x: left + (thickness / 4), y: mid - (thickness / 4)))
        iterimpathSelect.addLine(to: CGPoint(x: (right / 2) + (thickness / 2), y: first))
        
        iterimpath2Select = UIBezierPath()
        iterimpath2Select.move(to: CGPoint(x: left + (thickness / 4), y: mid + (thickness / 4)))
        iterimpath2Select.addLine(to: CGPoint(x: (right / 2) + (thickness / 2), y: third))
        
        iterimpath = UIBezierPath()
        iterimpath.move(to: CGPoint(x: left, y: first))
        iterimpath.addLine(to: CGPoint(x: right, y: first))
        
        iterimpath2 = UIBezierPath()
        iterimpath2.move(to: CGPoint(x: left, y: third))
        iterimpath2.addLine(to: CGPoint(x: right, y: third))
        
        opacity = 1.0
    }
    
    func bottomArrow() {
        
        iterimpathSelect = UIBezierPath()
        iterimpathSelect.move(to: CGPoint(x: right - (thickness / 4), y: mid - (thickness / 4)))
        iterimpathSelect.addLine(to: CGPoint(x: (right / 2) + (thickness / 2), y: third))
        
        iterimpath2Select = UIBezierPath()
        iterimpath2Select.move(to: CGPoint(x: left + (thickness / 4), y: mid + (thickness / 4)))
        iterimpath2Select.addLine(to: CGPoint(x: (right / 2) - (thickness / 2), y: third))
        
        iterimpath3Select = UIBezierPath()
        iterimpath3Select?.move(to: CGPoint(x: right / 2, y: first))
        iterimpath3Select?.addLine(to: CGPoint(x: (right / 2), y: third))
        
        iterimpath = UIBezierPath()
        iterimpath.move(to: CGPoint(x: left, y: first))
        iterimpath.addLine(to: CGPoint(x: right, y: first))
        
        iterimpath2 = UIBezierPath()
        iterimpath2.move(to: CGPoint(x: left, y: third))
        iterimpath2.addLine(to: CGPoint(x: right, y: third))
        
        iterimpath3 = UIBezierPath()
        iterimpath3?.move(to: CGPoint(x: left, y: mid))
        iterimpath3?.addLine(to: CGPoint(x: right, y: mid))
        
        opacity = 1.0
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if !preventCrossToggling {
            leftButStateIsMain = false
            toggle()
        } else {
            leftButStateIsMain = true
            selectedAction?(self, leftButStateIsMain)
        }
    }
    
}

