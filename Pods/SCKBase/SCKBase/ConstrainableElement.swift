//
//  ConstrainableElement.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-08-06.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit


public extension ConstrainableElement where Self : UIView {
    
    public func top(_ to: UIView,_ related: ConstraintElement,_ by: ConstraintVariables,_ secondary: (()->SecondaryContraintParameters)?) {
        guard let el = ConstraintYAxis(rawValue: related.rawValue) else { return }
        if by.secondary && block.secondaries != nil {
            block.secondaries?.topConstraint = self.topAnchor.constraint(equalTo: to.yAxisBy(el), constant: by.constant)
            return
        }
        block.topConstraint = self.topAnchor.constraint(equalTo: to.yAxisBy(el), constant: by.constant)
        if let sec = secondary, block.secondaries != nil {
            let secs = sec()
            guard let el = ConstraintYAxis(rawValue: secs.element.rawValue) else { return }
            block.secondaries?.topConstraint = self.topAnchor.constraint(equalTo: to.yAxisBy(el), constant: secs.vars.constant)
        }
    }
    
    public func bottom(_ to: UIView,_ related: ConstraintElement,_ by: ConstraintVariables,_ secondary: (()->SecondaryContraintParameters)?) {
        guard let el = ConstraintYAxis(rawValue: related.rawValue) else { return }
        if by.secondary && block.secondaries != nil {
            block.secondaries?.bottomConstraint = self.bottomAnchor.constraint(equalTo: to.yAxisBy(el), constant: by.constant)
            return
        }
        block.bottomConstraint = self.bottomAnchor.constraint(equalTo: to.yAxisBy(el), constant: by.constant)
        if let sec = secondary, block.secondaries != nil {
            let secs = sec()
            guard let el2 = ConstraintYAxis(rawValue: secs.element.rawValue) else { return }
            block.secondaries?.bottomConstraint = self.bottomAnchor.constraint(equalTo: to.yAxisBy(el2), constant: secs.vars.constant)
        }
    }
    
    public func right(_ to: UIView,_ related: ConstraintElement,_ by: ConstraintVariables,_ secondary: (()->SecondaryContraintParameters)?) {
        guard let el = ConstraintXAxis(rawValue: related.rawValue) else { return }
        if by.secondary && block.secondaries != nil {
            block.secondaries?.rightConstraint = self.trailingAnchor.constraint(equalTo: to.xAxisBy(el), constant: by.constant)
            return
        }
        block.rightConstraint = self.trailingAnchor.constraint(equalTo: to.xAxisBy(el), constant: by.constant)
        if let sec = secondary, block.secondaries != nil {
            let secs = sec()
            guard let el2 = ConstraintXAxis(rawValue: secs.element.rawValue) else { return }
            block.secondaries?.rightConstraint = self.trailingAnchor.constraint(equalTo: to.xAxisBy(el2), constant: secs.vars.constant)
        }
    }
    
    public func left(_ to: UIView,_ related: ConstraintElement,_ by: ConstraintVariables,_ secondary: (()->SecondaryContraintParameters)?) {
        guard let el = ConstraintXAxis(rawValue: related.rawValue) else { return }
        if by.secondary && block.secondaries != nil {
            block.secondaries?.leftConstraint = self.leadingAnchor.constraint(equalTo: to.xAxisBy(el), constant: by.constant)
            return
        }
        block.leftConstraint = self.leadingAnchor.constraint(equalTo: to.xAxisBy(el), constant: by.constant)
        if let sec = secondary, block.secondaries != nil {
            let secs = sec()
            guard let el2 = ConstraintXAxis(rawValue: secs.element.rawValue) else { return }
            block.secondaries?.leftConstraint = self.leadingAnchor.constraint(equalTo: to.xAxisBy(el2), constant: secs.vars.constant)
        }
    }
    
    public func vertical(_ to: UIView,_ related: ConstraintElement,_ by: ConstraintVariables,_ secondary: (()->SecondaryContraintParameters)?) {
        guard let el = ConstraintYAxis(rawValue: related.rawValue) else { return }
        if by.secondary && block.secondaries != nil {
            block.secondaries?.vertical = self.centerYAnchor.constraint(equalTo: to.yAxisBy(el), constant: by.constant)
            return
        }
        block.vertical = self.centerYAnchor.constraint(equalTo: to.yAxisBy(el), constant: by.constant)
        if let sec = secondary, block.secondaries != nil {
            let secs = sec()
            guard let el2 = ConstraintYAxis(rawValue: secs.element.rawValue) else { return }
            block.secondaries?.vertical = self.centerYAnchor.constraint(equalTo: to.yAxisBy(el2), constant: secs.vars.constant)
        }
    }
    
    public func horizontal(_ to: UIView,_ related: ConstraintElement,_ by: ConstraintVariables,_ secondary: (()->SecondaryContraintParameters)?) {
        guard let el = ConstraintXAxis(rawValue: related.rawValue) else { return }
        if by.secondary && block.secondaries != nil {
            block.secondaries?.horizontal = self.centerXAnchor.constraint(equalTo: to.xAxisBy(el), constant: by.constant)
            return
        }
        block.horizontal = self.centerXAnchor.constraint(equalTo: to.xAxisBy(el), constant: by.constant)
        if let sec = secondary, block.secondaries != nil {
            let secs = sec()
            guard let el2 = ConstraintXAxis(rawValue: secs.element.rawValue) else { return }
            block.secondaries?.horizontal = self.centerXAnchor.constraint(equalTo: to.xAxisBy(el2), constant: secs.vars.constant)
        }
    }
    
    public func height(_ to: UIView,_ related: ConstraintElement,_ by: ConstraintVariables,_ secondary: (()->SecondaryContraintParameters)?) {
        guard let el = ConstraintDimension(rawValue: related.rawValue) else { return }
        guard let m = by.multiplier else {
            if by.secondary && block.secondaries != nil {
                if by.fixed {
                    block.secondaries?.heightConstraint = self.heightAnchor.constraint(equalToConstant: by.constant)
                } else {
                    block.secondaries?.heightConstraint = self.heightAnchor.constraint(equalTo: to.dimensionBy(el), constant: by.constant)
                }
                return
            }
            if by.fixed {
                block.heightConstraint = self.heightAnchor.constraint(equalToConstant: by.constant)
            } else {
                block.heightConstraint = self.heightAnchor.constraint(equalTo: to.dimensionBy(el), constant: by.constant)
            }
            if let sec = secondary, block.secondaries != nil {
                let secs = sec()
                guard let el2 = ConstraintDimension(rawValue: secs.element.rawValue) else { return }
                if secs.vars.fixed {
                    block.secondaries?.heightConstraint = self.heightAnchor.constraint(equalToConstant: secs.vars.constant)
                } else {
                    block.secondaries?.heightConstraint = self.heightAnchor.constraint(equalTo: to.dimensionBy(el2), constant: secs.vars.constant)
                }
            }
            return
        }
        if by.secondary && block.secondaries != nil {
            if by.fixed {
                block.secondaries?.heightConstraint = self.heightAnchor.constraint(equalToConstant: by.constant)
            } else {
                block.secondaries?.heightConstraint = self.heightAnchor.constraint(equalTo: to.dimensionBy(el), multiplier: m, constant: by.constant)
            }
            return
        }
        if by.fixed {
            block.heightConstraint = self.heightAnchor.constraint(equalToConstant: by.constant)
        } else {
            block.heightConstraint = self.heightAnchor.constraint(equalTo: to.dimensionBy(el), multiplier: m, constant: by.constant)
        }
        if let sec = secondary, block.secondaries != nil {
            let secs = sec()
            guard let el2 = ConstraintDimension(rawValue: secs.element.rawValue) else { return }
            if by.fixed {
                block.secondaries?.heightConstraint = self.heightAnchor.constraint(equalToConstant: secs.vars.constant)
            } else {
                block.secondaries?.heightConstraint = self.heightAnchor.constraint(equalTo: to.dimensionBy(el2), multiplier: m, constant: secs.vars.constant)
            }
        }
    }
    
    public func width(_ to: UIView,_ related: ConstraintElement,_ by: ConstraintVariables,_ secondary: (()->SecondaryContraintParameters)?) {
        guard let el = ConstraintDimension(rawValue: related.rawValue) else { return }
        guard let m = by.multiplier else {
            if by.secondary && block.secondaries != nil {
                if by.fixed {
                    block.secondaries?.widthConstraint = self.widthAnchor.constraint(equalToConstant: by.constant)
                } else {
                    block.secondaries?.widthConstraint = self.widthAnchor.constraint(equalTo: to.dimensionBy(el), constant: by.constant)
                }
                return
            }
            if by.fixed {
                block.widthConstraint = self.widthAnchor.constraint(equalToConstant: by.constant)
            } else {
                block.widthConstraint = self.widthAnchor.constraint(equalTo: to.dimensionBy(el), constant: by.constant)
            }
            if let sec = secondary, block.secondaries != nil {
                let secs = sec()
                guard let el2 = ConstraintDimension(rawValue: secs.element.rawValue) else { return }
                if secs.vars.fixed {
                    block.secondaries?.widthConstraint = self.widthAnchor.constraint(equalToConstant: secs.vars.constant)
                } else {
                    block.secondaries?.widthConstraint = self.widthAnchor.constraint(equalTo: to.dimensionBy(el2), constant: secs.vars.constant)
                }
            }
            return
        }
        if by.secondary && block.secondaries != nil {
            if by.fixed {
                block.secondaries?.widthConstraint = self.widthAnchor.constraint(equalToConstant: by.constant)
            } else {
                block.secondaries?.widthConstraint = self.widthAnchor.constraint(equalTo: to.dimensionBy(el), multiplier: m, constant: by.constant)
            }
            return
        }
        if by.fixed {
            block.widthConstraint = self.widthAnchor.constraint(equalToConstant: by.constant)
        } else {
            block.widthConstraint = self.widthAnchor.constraint(equalTo: to.dimensionBy(el), multiplier: m, constant: by.constant)
        }
        if let sec = secondary, block.secondaries != nil {
            let secs = sec()
            guard let el2 = ConstraintDimension(rawValue: secs.element.rawValue) else { return }
            if by.fixed {
                block.secondaries?.widthConstraint = self.widthAnchor.constraint(equalToConstant: secs.vars.constant)
            } else {
                block.secondaries?.widthConstraint = self.widthAnchor.constraint(equalTo: to.dimensionBy(el2), multiplier: m, constant: secs.vars.constant)
            }
        }
    }
    
    public func apply(_ action: @escaping(()->()),_ action2: (()->())?){
        block.primary = action
        block.secondary = action2
        block.primaryAndSecondaryCanToggle = true
    }
    
    public var constrainableType : ConstrainableElementType {
        get {
            if (element.self == Button.self) {
                return .button
            }
            if (element.self == ImageView.self) {
                return .imageView
            }
            if (element.self == View.self) {
                return .view
            }
            if (element.self == Label.self) {
                return .label
            }
            return .textField
        }
    }
    
    public var canBeToggled : Bool {
        get {
            return self.block.primaryAndSecondaryCanToggle
        }
    }
    
}

open class ConstraintVariables {
    public var multiplier : CGFloat?
    public var constant : CGFloat = 0
    public var related : Int = 0
    public var fixed : Bool = false
    public var secondary : Bool = false
    public init(_ related: ConstraintElement,_ c: CGFloat) {
        constant = c
        self.related = related.rawValue
    }
    public func m(_ v: CGFloat) -> ConstraintVariables {
        multiplier = v
        return self
    }
    public func fixConstant() -> ConstraintVariables {
        fixed = true
        return self
    }
    public func makeSecondary() -> ConstraintVariables {
        secondary = true
        return self
    }
}

public protocol ConstrainableElement: Constrainable {
    
    associatedtype element : Constrainable
    
    var constrainableType : ConstrainableElementType { get }
    
    var canBeToggled : Bool { get }
    
    func top(_ to: UIView,_ related: ConstraintElement,_ by: ConstraintVariables,_ secondary: (()->SecondaryContraintParameters)?)
    
    func bottom(_ to: UIView,_ related: ConstraintElement,_ by: ConstraintVariables,_ secondary: (()->SecondaryContraintParameters)?)
    
    func right(_ to: UIView,_ related: ConstraintElement,_ by: ConstraintVariables,_ secondary: (()->SecondaryContraintParameters)?)
    
    func left(_ to: UIView,_ related: ConstraintElement,_ by: ConstraintVariables,_ secondary: (()->SecondaryContraintParameters)?)
    
    func vertical(_ to: UIView,_ related: ConstraintElement,_ by: ConstraintVariables,_ secondary: (()->SecondaryContraintParameters)?)
    
    func horizontal(_ to: UIView,_ related: ConstraintElement,_ by: ConstraintVariables,_ secondary: (()->SecondaryContraintParameters)?)
    
    func height(_ to: UIView,_ related: ConstraintElement,_ by: ConstraintVariables,_ secondary: (()->SecondaryContraintParameters)?)
    
    func width(_ to: UIView,_ related: ConstraintElement,_ by: ConstraintVariables,_ secondary: (()->SecondaryContraintParameters)?)
    
    func apply(_ action: @escaping(()->()),_ action2: (()->())?)
    
}
