//
//  UILabel+Instantiables.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-06-13.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit
public protocol ExpressibleByNumberArrayLiteral: ExpressibleByArrayLiteral {
    associatedtype Element
}

public protocol Makeable: ExpressibleByNumberArrayLiteral {
    // we want `init()` but we are unable to satisfy such a protocol from `UILabel`, thus we need this work around
    associatedtype SelfType
    static func make(values: [Element]) -> SelfType
}

public protocol Instantiatable: ExpressibleByNumberArrayLiteral {
    init(values: [Element])
}

extension Makeable {
    public init(arrayLiteral elements: Self.Element...) {
        self = Self.make(values: elements) as! Self
    }
}

extension Instantiatable {
    public init(arrayLiteral elements: Self.Element...) {
        self.init(values: elements)
    }
}

postfix operator ^

public postfix func ^<I: Instantiatable>(attributes: [I.Element]) -> I {
    return I(values: attributes)
}

extension ExpressibleByNumberArrayLiteral where Self: Makeable {
    public init(arrayLiteral elements: Self.Element...) {
        self = Self.make(values: elements) as! Self
    }
}

extension ExpressibleByNumberArrayLiteral where Self: Instantiatable {
    init(arrayLiteral elements: Self.Element...) {
        self.init(values: elements)
    }
}

extension UILabel: Makeable {
    public typealias SelfType = UILabel
    public typealias Element = Int
    
    public static func make(values: [Element]) -> SelfType {
        let label = UILabel()
        label.text = "Sum: \(values.reduce(0,+))"
        return label
    }
}

open class ExpressibleNumberLabel: UILabel, Instantiatable {
    private var presetted : Bool = false
    open var pre_text : String? {
        didSet {
            guard presetted else {
                if let t = pre_text, let te = text {
                    text = t + te
                    presetted = true
                } else if let t = pre_text {
                    text = t
                    presetted = true
                } else {
                    presetted = false
                }
                return
            }
            if let t = pre_text {
                guard let v = value else {
                    return
                }
                let comps = v.components(separatedBy: " ")
                let setted = comps[comps.count - 1]
                text = t + setted
            } else if let t = pre_text {
                text = t
            }
        }
    }
    
    open var value : String? {
        get {
            guard let  t = self.text else {
                return nil
            }
            guard let pre = pre_text else {
                return t
            }
            return pre + " " + t
        }
    }
    
    
    public typealias Element = Int
    required public init(values: [Element]) {
        super.init(frame: .zero)
        text = "\(values.reduce(0,+))"
    }
    
    public required init?(coder: NSCoder) { fatalError() }
}



