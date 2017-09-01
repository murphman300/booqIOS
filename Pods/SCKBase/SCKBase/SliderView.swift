//
//  SliderView.swift
//  Spotit
//
//  Created by Jean-Louis Murphy on 2017-04-05.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit


open class SliderView : UIView, UIGestureRecognizerDelegate {
    
    open weak var delegate : SliderViewDelegate?
    
    private var moveSuperView : Bool = false
    
    open var doesMoveSuperView: Bool {
        get {
            return moveSuperView
        } set {
            moveSuperView = newValue
        }
    }
    private var shadow : Bool = false
    
    private var radius : CGFloat?
    
    private var customShadowColor: UIColor = UIColor.clear
    private var animationSpeed : TimeInterval = 0.35
    private var closedW = CGFloat()
    private var openW = CGFloat()
    private var widthRatioDifference: CGFloat = 0
    private var resizesWSlide: Bool = false
    private var widthResizeToMinimumRatio : CGFloat = 0.95
    private var sliderIsOpen : Bool = false
    private var doesSlide : Bool = false
    
    open var closedWidthRatio : CGFloat = 1
    
    open var sliderOptions = [SliderViewSettingsOptions]()
    
    open var hasSlideEnabled : Bool {
        get {
            return doesSlide
        } set {
            doesSlide = newValue
        }
    }
    
    open var isOpen: Bool {
        get {
            return sliderIsOpen
        } set {
            sliderIsOpen = newValue
        }
    }
    
    open var sliderViewHasShadow : Bool {
        get {
            return shadow
        } set {
            shadow = newValue
        }
    }
    
    open var colorOfRoundShadow : UIColor {
        get {
            return customShadowColor
        } set {
            customShadowColor = newValue
        }
    }
    
    open var sliderViewCornerRadius : CGFloat {
        get {
            guard let rad = radius else {
                return 0
            }
            return rad
        } set {
            radius = newValue
        }
    }
    
    open var sliderAnimationSpeed: TimeInterval {
        get {
            return animationSpeed
        } set {
            animationSpeed = newValue
        }
    }
    
    open var resizesWidthOnSlide: Bool {
        get {
            return resizesWSlide
        } set {
            resizesWSlide = newValue
        }
    }
    
    private var ratioDifference : CGFloat {
        get {
            guard resizesWidthOnSlide else {
                return 0
            }
            return 1 - closedWidthRatio
        }
    }
    
    open var slider : UIView = {
        var v = UIView()
        return v
    }()
    
    open var closedCent = CGFloat()
    open var upCent = CGFloat()
    private var tab : CGFloat?
    private var uppedTab : CGFloat?
    private var superdiffH : CGFloat?
    private var dot : Bool = false
    
    open var closedTab : CGFloat {
        get {
            guard let ta = tab else {
                return 40
            }
            return ta
            
        } set {
            guard let sup = superview else {
                tab = newValue
                dot = true
                return
            }
            superdiffH = sup.frame.height - frame.height
            tab = newValue
            let norm = sup.frame.height + (frame.height / 2)
            closedCent = norm - newValue
        }
    }
    
    open var upTab : CGFloat {
        get {
            return upCent
        } set {
            guard let sup = superview else {
                uppedTab = newValue
                return
            }
            upCent = (sup.frame.minY) + newValue + (frame.height / 2)
        }
    }
    
    open var stop : Bool = true
    
    open var pan = UIPanGestureRecognizer()
    
    open var top : UIView = {
        var v = UIView()
        return v
    }()
    
    public override init(frame: CGRect) {
        guard let t = tab else {
            super.init(frame: frame)
            //set()
            NotificationCenter.default.addObserver(self, selector: #selector(isOpenChecker), name: NSNotification.Name.init("NotifyFeedThatMainIntHasAppeared"), object: nil)
            return
        }
        let rec = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height - t)
        super.init(frame: rec)
        NotificationCenter.default.addObserver(self, selector: #selector(isOpenChecker), name: NSNotification.Name.init("NotifyFeedThatMainIntHasAppeared"), object: nil)
    }
    
    open func set() {
        addSubview(slider)
        slider.addSubview(top)
        slider.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        top.frame = CGRect(x: 0, y: 0, width: slider.frame.width, height: buttonSizes.mainheight)
        top.backgroundColor = colors.loginTfBack
        setsSliderView(options: sliderOptions)
        pan.addTarget(self, action: #selector(panning(sender:)))
        top.addGestureRecognizer(pan)
        if dot {
            guard let t = tab else {
                return
            }
            closedTab = t
            dot = false
            guard uppedTab != nil else {
                return
            }
            guard let sup = superview else {
                return
            }
            upCent = (sup.frame.height) - (frame.height / 2)
            print(upCent, "IS UPCENT")
            shadowSetter()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func panning(sender: UIPanGestureRecognizer) {
        guard let superv = superview else {
            return
        }
        guard doesSlide else {
            return
        }
        let diff = self.closedCent - self.upCent
        guard sender == pan else {
            return
        }
        guard stop else {
            return
        }
        let move = sender.translation(in: top)
        guard move.y < 0 else {
            guard center.y >= upCent else {
                return
            }
            guard (center.y != closedCent) else {
                return
            }
            guard sender.state == .ended else {
                self.center.y = self.upCent + move.y
                delegateMethodParser(self.upCent + move.y, diff, false)
                return
            }
            guard center.y >= (superv.frame.height * 0.7) else {
                delegateMethodParser(self.upCent, diff, true)
                return
            }
            delegateMethodParser(self.closedCent, diff, true)
            return
        }
        guard center.y <= closedCent else {
            return
        }
        guard center.y != upCent else {
            return
        }
        guard sender.state == .ended else {
            
            self.center.y = self.closedCent + move.y
            
            delegateMethodParser(self.closedCent + move.y, diff, false)
            
            return
        }
        guard center.y >= (superv.frame.height) else {
            delegateMethodParser(self.upCent, diff, true)
            return
        }
        stop = false
        delegateMethodParser(self.closedCent, diff, true)
    }
    
    private func delegateMethodParser(_ to: CGFloat,_ within: CGFloat,_ animating: Bool) {
        var scale = CGFloat()
        var new = CGFloat()
        guard animating else {
            guard doesMoveSuperView else {
                //moves itself
                delegate?.sliderView(sliderView: self, isPanningTo: to, within: within)
                if resizesWidthOnSlide {
                    scale = (to - self.upCent)/(self.closedCent - self.upCent)
                    let new = 1 - (ratioDifference * scale)
                    let transf = CGAffineTransform(scaleX: new, y: 1)
                    transform = transf
                }
                return
            }
            //super view
            delegate?.sliderView(sliderView: self, didMove: to, within: within)
            return
        }
        guard doesMoveSuperView else {
            //moves itself animated
            self.stop = false
            UIView.animate(withDuration: animationSpeed, animations: {
                self.center.y = to
            }, completion: {
                value in
                self.stop = true
            })
            if resizesWidthOnSlide {
                UIView.animate(withDuration: animationSpeed, animations: {
                    scale = (to - self.upCent)/(self.closedCent - self.upCent)
                    new = 1 - (self.ratioDifference * scale)
                    let transf = CGAffineTransform(scaleX: new, y: 1)
                    self.transform = transf
                }, completion: {
                    value in
                })
            }
            delegate?.sliderView(sliderView: self, didSlideToPlace: to, within: within)
            return
        }
        //super view animated
        delegate?.slideView(sliderView: self, didAnimate: to, within: within)
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        /*set()
         if dot {
         guard let t = tab else {
         return
         }
         closedTab = t
         dot = false
         guard uppedTab != nil else {
         return
         }
         guard let sup = superview else {
         return
         }
         upCent = (sup.frame.height) - (frame.height / 2)
         shadowSetter()
         addSubview(slider)
         
         }*/
    }
    
    override open func removeFromSuperview() {
        super.removeFromSuperview()
        dot = false
    }
    
    private func shadowSetter() {
        
        guard shadow else {
            return
        }
        if let rad = radius {
            
            layer.shadowRadius = rad
            slider.roundCorners([.topLeft, .topRight], rad)
        }
        layer.shadowColor = customShadowColor.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0.0, height: -15.0)
        layer.shadowPath = UIBezierPath(rect: slider.bounds).cgPath
        //layer.shouldRasterize = true
        
    }
    
    public func setWidthsFromRatio(_ sup : UIView) {
        
        let factor = closedWidthRatio / 1
        closedW = sup.frame.width
        openW = frame.width * factor
        widthRatioDifference = closedW - openW
        
    }
    
    open func slideUp() {
        
        delegateMethodParser(upCent, closedCent - upCent, true)
        
    }
    
    open func slideDown() {
        delegateMethodParser(closedCent, closedCent - upCent, true)
    }
    
    public func isOpenChecker() {
        
        guard sliderIsOpen else {
            slideUp()
            return
        }
        slideDown()
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private func setsSliderView(options: [SliderViewSettingsOptions]) {
        for item in options {
            if item == .doesMoveSuperView {
                self.doesMoveSuperView = true
            }
            if item == .doesSlide {
                self.doesSlide = true
            }
            if item == .resizesWithSlide {
                self.resizesWSlide = true
            }
            if item == .isOpenOnAppear {
                self.isOpen = true
            }
            if item == .hasShadow {
                self.shadow = true
            }
        }
        
    }
    
}

@objc public protocol SliderViewDelegate : class {
    
    func sliderView(sliderView: SliderView, didSlideToPlace: CGFloat, within: CGFloat)
    
    func sliderView(sliderView: SliderView, isPanningTo: CGFloat, within: CGFloat)
    
    func sliderView(sliderView: SliderView, didMove superViewTo: CGFloat, within: CGFloat)
    
    func slideView(sliderView: SliderView, didAnimate superviewTo: CGFloat, within: CGFloat)
    
}


public enum SliderViewSettingsOptions : CGFloat, RawRepresentable {
    
    case doesSlide
    case doesMoveSuperView
    case resizesWithSlide
    case isOpenOnAppear
    case hasShadow
    
}

public enum radii : CGFloat {
    case five = 5
    case ten = 10
    case fifteen = 15
    case twenty = 20
}

public struct HasCornerRadius {
    private var value : radii
    
    public var ofValue : radii {
        get {
            return value
        } set {
            value = newValue
        }
    }
}
