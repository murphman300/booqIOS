//
//  App-Class.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation

open class App: NSObject {
    
    public static let defaults = App()
    private var isLoggedIn : Bool?
    private var isConfigured : Bool?
    
    public override init() {
        
        isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        isConfigured = UserDefaults.standard.bool(forKey: "isConfigured")
        
    }
    
    public var loggedIn : Bool {
        get {
            guard let lo = isLoggedIn else {
                return false
            }
            return lo
        }
    }
    
    public var configured : Bool {
        get {
            guard let lo = isConfigured else {
                return false
            }
            return lo
        }
    }
    
}
