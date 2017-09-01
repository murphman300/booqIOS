//
//  MultiVar.swift
//  Checkout
//
//  Created by Jean-Louis Murphy on 2017-02-19.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit


open class MultiVar: NSObject  {
    private var s: String?
    private var int: Int?
    private var c: CGFloat?
    
    private var alph = "abcdefghijklmnopqrstuvwxyzABCDEFGHIKLMNOPQRSTUVWXYZ!@#$%^&*()_+}{|:'/<>?()[]"
    
    public override init() {
        super.init()
    }
    
    open var nulls : Bool {
        get {
            return true
        } set {
            s = nil
        }
    }
    
    open var nulli : Bool {
        get {
            return true
        } set {
            int = nil
            c = nil
        }
    }
    
    open var string : String {
        get {
            if s != nil {
                return s!
            } else {
                return ""
            }
        }
    }
    
    open var integer : Int {
        get {
            if int != nil {
                return int!
            } else {
                return 0
            }
        }
    }
    
    open var cgFloat : CGFloat {
        get {
            if c != nil {
                return c!
            } else {
                return 0
            }
        }
    }
    
    public func stringValue(_ byFactor: Int) -> String? {
        let new = integer * byFactor
        let res = String(describing: new)
        return res
    }
    
    public func set(_ i: Any) {
        if Mirror(reflecting: i).subjectType == Mirror(reflecting: Int()).subjectType {
            if let it = i as? Int {
                int = it
                c = CGFloat(int!)
                if int! < 10 && int! > 0 {
                    s = "0\(String(describing: int!))"
                } else {
                    s = String(describing: int!)
                }
            }
        }
        if Mirror(reflecting: i).subjectType == Mirror(reflecting: String()).subjectType {
            
            s = String(describing: i)
            if isNonAlpha() {
                int = Int(s!)
                c = CGFloat(Int(s!)!)
                if int! < 10 && int! > 0 {
                    s = "0\(s!)"
                }
                if s?.characters.first! == "0" && s?.characters.count == 3 && int! > 0 || s?.characters.count == 1 {
                    s = String(describing: i)
                }
            }
        }
        if Mirror(reflecting: i).subjectType == Mirror(reflecting: CGFloat()).subjectType {
            if let cg = i as? CGFloat {
                c = cg
                int = Int(c!)
                s = String(describing: c)
                if int! < 10 && int! > 0 {
                    s = "0\(s!)"
                }
            }
        }
    }
    private func isNonAlpha() -> Bool {
        var b = Bool()
        if s != nil {
            b = !keyboard.alph.contains(s!)
        }
        return b
    }
}

