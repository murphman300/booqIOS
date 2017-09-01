//
//  State.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation


public enum States {
    
    
}

open class State {
    private var geo = GeoVar()
    
    open var str = String()
    
    public init(){
        
    }
    
    public func set(_ name: String) {
        geo.province = name
    }
    
    open var name : String? {
        get {
            guard let n = geo.province else {
                return nil
            }
            return n
        }
    }
    
    open var code : String? {
        get {
            guard let n = geo.short else {
                return nil
            }
            return n
        }
    }
}
