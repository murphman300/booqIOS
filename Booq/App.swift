//
//  App.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-04.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation

open class App: NSObject {
    
    public static let defaults = App()
    private var isLoggedIn : Bool?
    private var isConfigured : Bool?
    var leftApp : Bool = false
    
    public override init() {
        
        isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        isConfigured = UserDefaults.standard.bool(forKey: "isConfigured")
        
    }
    
    func initialize() {
        
    }
    
    public func logIn() {
        loggedIn = true
    }
    
    public func configure() {
        configured = true
    }
    
    func applyLocalInformation() {
        
    }
    
    public var loggedIn : Bool {
        get {
            guard let lo = isLoggedIn else {
                return false
            }
            return lo
        } set {
            isLoggedIn = newValue
            UserDefaults.standard.set(newValue, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
        }
    }
    
    public var configured : Bool {
        get {
            guard let lo = isConfigured else {
                return false
            }
            return lo
        } set {
            isConfigured = newValue
            UserDefaults.standard.set(newValue, forKey: "isConfigured")
            UserDefaults.standard.synchronize()
        }
    }
    
}
