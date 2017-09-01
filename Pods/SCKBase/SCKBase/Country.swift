//
//  Country.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation

enum Countries: String {
    
    case can = "Canada"
    
    public init() {
        self = Countries(rawValue: "Canada")!
    }
    
    public func parseToPair(_ value: String) -> GeoVar.CountryPair? {
        var n : GeoVar.CountryPair?
        for v in array() {
            if v.rawValue.contains(value) {
                let short = shorts()
                if let sc = short[v] {
                    n = GeoVar.CountryPair()
                    n?.chortCode = sc
                    n?.country = v.rawValue
                }
                break
            }
        }
        return n
    }
    
    private func array() -> [Countries] {
        return [.can]
    }
    
    private func shorts() -> [Countries: String] {
        
        return [.can: "CA"]
        
    }
    
}
