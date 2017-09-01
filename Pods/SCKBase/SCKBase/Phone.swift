//
//  Phone.swift
//  Checkout
//
//  Created by Jean-Louis Murphy on 2017-01-17.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit

open class Phone {
    open var number = MainDigits()
    open var regional = RegionalCode()
    private var isSet : Bool = false
    
    public init() {
        
    }
    
    open var display : String {
        get {
            return "\(regional.display)-\(number.prefixes)-\(number.suffixes)"
        }
    }
    
    open var compact : String {
        get {
            return "\(regional.compact)\(number.prefixes)\(number.suffixes)"
        }
    }
    
    open var stpCompact : String {
        get {
            return "\(regional.area)\(number.prefixes)\(number.suffixes)"
        }
    }
    
    open func set(_ code: String,_ pref: String,_ suf: String) {
        number.set(pref, suf)
        regional.set(code)
        isSet = true
    }
    
    open func set(_ code: Int,_ pref: Int,_ suf: Int) {
        number.set(pref, suf)
        regional.set(code)
        isSet = true
    }
    
    open var suffix: Int {
        get {
            return number.suffixes
        } set {
            number.suffixes = suffix
        }
    }
    
    open var prefix: Int {
        get {
            return number.prefixes
        } set {
            number.prefixes = prefix
        }
    }
    
    open var code: Int {
        get {
            return regional.code
        }
    }
    
    open var canBeObject: Bool {
        get {
            guard isSet else {
                return false
            }
            return true
        }
    }
    
    open var dict : [String:String] {
        get {
            guard canBeObject else {
                return [:]
            }
            return ["compact": compact, "display": display]
        }
    }
    
    open var dataObject : Data? {
        get {
            let obj = dict
            do {
                guard dict.isEmpty else {
                    let data = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    return data
                }
                return nil
            } catch {
                return nil
            }
        }
    }
    
    
    open class MainDigits {
        private var pre = MultiVar()
        
        public init() {
            
        }
        
        open var prefixes : Int {
            get {
                return pre.integer
            } set {
                pre.set(newValue)
            }
        }
        private var suf  = MultiVar()
        
        open var suffixes : Int {
            get {
                return suf.integer
            } set {
                suf.set(newValue)
            }
        }
        
        public func set(_ pref: Int, _ sufx: Int) {
            pre.set(pref)
            suf.set(sufx)
        }
        
        public func set(_ pref: String, _ sufx: String) {
            pre.set(pref)
            suf.set(sufx)
        }
        
        deinit {
            
        }
    }
    open class RegionalCode {
        private var co  = MultiVar()
        private var reg = String()
        
        public func set(_ code: Int) {
            co.set(code)
            if canada.contains(code) {
                reg = "+1"
            }
        }
        
        public func set(_ code: String) {
            co.set(code)
            if stCanada.contains(code) {
                guard reg.isEmpty else {
                    return
                }
                reg = "+1"
            }
        }
        
        open var code : Int {
            get {
                return co.integer
            }
        }
        
        open var display : String {
            get {
                var st = String()
                guard reg.isEmpty else {
                    st = reg
                    
                    return "\(st)-\(co.string)"
                }
                return "\(co.string)"
            }
        }
        
        open var compact : String {
            get {
                var st = String()
                guard reg.isEmpty else {
                    st = reg
                    return "\(st)\(co.string)"
                }
                return "\(co.string)"
            }
        }
        
        open var area : String {
            get {
                var st = String()
                guard reg.isEmpty else {
                    st = reg
                    return "\(co.string)"
                }
                return "\(co.string)"
            }
        }
        
        private var canada = [514, 613, 819]
        private var stCanada = ["514", "613", "819"]
    }
    
    deinit {
        
    }
}
