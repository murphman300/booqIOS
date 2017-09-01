//
//  Provinces.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation

public enum Provinces: String {
    case qc = "Quebec"
    case ont = "Ontario"
    case bc = "British Columbia"
    case mani = "Manitoba"
    case nflab = "Newfoundland and Labrador"
    case nv = "Nova Scotia"
    case sask = "Saskatchewan"
    case alb = "Alberta"
    case pei = "Prince Edward Island"
    case nb = "New Brunswick"
    case nun = "Nunavut"
    case nwt = "Northwest Territories"
    case yuk = "Yukon"
    
    public init() {
        self = Provinces(rawValue: "Quebec")!
    }
    
    public func parseToPair(_ value: String) -> GeoVar.StatePair? {
        var n : GeoVar.StatePair?
        for v in array() {
            if v.rawValue.contains(value) {
                let short = shorts()
                if let sc = short[v] {
                    n = GeoVar.StatePair()
                    n?.chortCode = sc
                    n?.state = v.rawValue
                }
                break
            }
        }
        return n
    }
    
    public func array() -> [Provinces] {
        return [.qc, .ont, .bc, .mani, .nflab, .nv, .sask, .alb, .pei, .nb, .nun, .nwt, .yuk]
    }
    
    public func shorts() -> [Provinces: String] {
        
        return [.qc: "QC", .ont: "ON", .bc: "BC", .mani: "MA", .nflab: "NL", .nv: "NV", .sask: "SK", .alb: "AB", .pei: "PE", .nb: "NB", .nun: "NV", .nwt: "NT", .yuk: "YK"]
        
    }
}



open class Country {
    private var geo = GeoVar()
    
    public init(){
        
    }
    
    func set(_ name: String) {
        geo.country = name
    }
    func setCode(_ name: String) {
        
    }
    var str = String()
    var name : String? {
        get {
            guard let n = geo.country else {
                return nil
            }
            return n
        }
    }
    
    var code : String? {
        get {
            guard let n = geo.short else {
                return nil
            }
            return n
        }
    }
}
