//
//  GeoVar.swift
//  Spotit
//
//  Created by Jean-Louis Murphy on 2017-04-05.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit


open class GeoVar {
    private var data : StatePair?
    private var cdata : CountryPair?
    
    public init() {
        
    }
    
    var province : String? {
        get {
            guard let d = data else {
                return nil
            }
            return d.state
        } set {
            guard let n = newValue else {
                return
            }
            guard let pair = Provinces().parseToPair(n) else {
                return
            }
            if cdata != nil {
                cdata = nil
            }
            data = pair
        }
    }
    
    var country: String? {
        get {
            guard let d = cdata else {
                return nil
            }
            return d.country
        } set {
            guard let n = newValue else {
                return
            }
            guard let pair = Countries().parseToPair(n) else {
                return
            }
            if data != nil {
                data = nil
            }
            cdata = pair
        }
    }
    
    var short : String? {
        get {
            guard let d = data else {
                guard let c = cdata else {
                    return nil
                }
                return c.chortCode
            }
            return d.chortCode
        }
    }
    
    open class StatePair {
        var chortCode = String()
        var state = String()
        
    }
    open class CountryPair {
        var chortCode = String()
        var country = String()
    }
}

