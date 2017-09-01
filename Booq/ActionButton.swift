//
//  ActionButton.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-04.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

enum ProfileHeaderType {
    case edit
    case add
    case null
}

protocol ProfileHeaderActionButtonDelegate {
    func header(button: ActionButton, wasPressed info : Any?)
}

class ActionButton : Button {
    
    var delegate : ProfileHeaderActionButtonDelegate?
    var touchedColor : UIColor?
    var untouchedColor : UIColor?
    let basicBlue: UIColor = UIColor.rgb(red: 0, green: 128, blue: 255)
    
    var attributes : [String:Any]?
    
    var actionType: ProfileHeaderType? {
        didSet {
            if let t = actionType {
                switch t {
                case .edit :
                    setupForEdit()
                case .add :
                    setUpForAdd()
                case .null :
                    buildPlusSign()
                }
            }
        }
    }
    
    var cornerRadius = CGFloat() {
        didSet{
            if shadowed {
                applyRadiusToShadow(cornerRadius)
            } else {
                layer.cornerRadius = cornerRadius
            }
        }
    }
    
    var shadowed = Bool() {
        didSet {
            guard shadowed && hasSecondaries else {
                layer.shadowColor = UIColor.clear.cgColor
                layer.shadowOpacity = 0.0
                return
            }
            guard frame.height > 0 else {
                layer.shadowColor = UIColor.clear.cgColor
                layer.shadowOpacity = 0.0
                return
            }
            applyRadiusToShadow(cornerRadius)
        }
    }
    
    private func determineCornerRadius(_ value: CGFloat) -> CGFloat {
        guard let height = block.heightConstraint,  let width = block.widthConstraint, height.constant == width.constant else {
            return cornerRadius
        }
        return height.constant / 2
    }
    
    private func applyRadiusToShadow(_ value: CGFloat) {
        let radius : CGFloat = determineCornerRadius(value)
        let height = frame.height
        if let height = block.heightConstraint {
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: height.constant, height: height.constant), cornerRadius: radius).cgPath
            layer.shadowPath = path
            layer.shadowRadius = 6.0
            layer.shadowOffset = CGSize(width: 0, height: 8)
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.5
            layer.cornerRadius = radius
            return
        }
        guard frame.height == frame.width else {
            if frame.height > frame.width {
                //tall rect
                let height = frame.height
                let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.width, height: height), cornerRadius: radius).cgPath
                layer.shadowPath = path
                layer.shadowRadius = 6.0
                layer.shadowOffset = CGSize(width: 0, height: 6)
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOpacity = 0.5
            } else {
                //wide rect
                let height = frame.height
                let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.width, height: height), cornerRadius: radius).cgPath
                layer.shadowPath = path
                layer.shadowRadius = 6.0
                layer.shadowOffset = CGSize(width: 0, height: 6)
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOpacity = 0.5
            }
            layer.cornerRadius = cornerRadius
            return
        }
        //square
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.width, height: height), cornerRadius: radius).cgPath
        layer.shadowPath = path
        layer.shadowRadius = 6.0
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.cornerRadius = cornerRadius
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchedAction?()
        touchTransition?()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        unTouchedAction?()
        untouchTransition?()
        if let d = delegate {
            d.header(button: self, wasPressed: nil)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        unTouchedAction?()
    }
    
    private var touchedAction : (()->())?
    
    private var unTouchedAction : (()->())?
    
    var untouchTransition : (()->())?
    
    var touchTransition : (()->())?
    
    private var signLayer : CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = fonts.secButtonBold
    }
    
    convenience init<T:UIViewController>(secondaries: Bool, delegate: T) where T: ProfileHeaderActionButtonDelegate {
        self.init(secondaries: secondaries)
        self.delegate = delegate
    }
    
    convenience init<T:UIViewController>(delegate: T) where T: ProfileHeaderActionButtonDelegate {
        self.init(frame: .zero)
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpForAdd(){
        backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 255)
        setTitleColor(colors.loginTfBack, for: .normal)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        self.touchedAction = {
            if let c = self.touchedColor {
                self.backgroundColor = c
            } else {
                self.backgroundColor = colors.lightBlueMainColor
            }
        }
        self.unTouchedAction = {
            if let c = self.untouchedColor {
                self.backgroundColor = c
            } else {
                self.backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 255)
            }
        }
        if let c = self.untouchedColor {
            self.backgroundColor = c
        }
        setUpImage()
    }
    
    private func setupForEdit() {
        backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 255)
        setTitleColor(colors.loginTfBack, for: .normal)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        self.touchedAction = {
            if let c = self.touchedColor {
                self.backgroundColor = c
            } else {
                self.backgroundColor = colors.lightBlueMainColor
            }
        }
        self.unTouchedAction = {
            if let c = self.untouchedColor {
                self.backgroundColor = c
            } else {
                self.backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 255)
            }
        }
        if let c = self.untouchedColor {
            self.backgroundColor = c
        }
        
        setUpImage()
    }
    
    private func buildPlusSign() {
        self.touchedAction = {
            if let c = self.touchedColor {
                self.backgroundColor = c
            } else {
                self.backgroundColor = colors.lightBlueMainColor
            }
        }
        self.unTouchedAction = {
            if let c = self.untouchedColor {
                self.backgroundColor = c
            } else {
                self.backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 255)
            }
        }
        if let c = self.untouchedColor {
            self.backgroundColor = c
        }
        
        setUpImage()
    }
    
    func setUpImage() {
        
    }
    
    func setAttribute(_ key: String,_ value: Any) {
        if attributes == nil {
            attributes = [:]
        }
        attributes?[key] = value
    }
    
    func attribute(_ key: String) -> String {
        guard let att = attributes, let value = att[key] as? String else {
            return ""
        }
        return value
    }
    
}
