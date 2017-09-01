//
//  Double+Helper.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation


extension Double {
    
    public func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    
    public func setCurrencyLabel() -> CGFloat {
        
        let value = self * 100
        
        let subtotal = value * Double(1 - CanadianTaxRates.quebec.tps - CanadianTaxRates.quebec.tvq)
        let round = CGFloat(subtotal.rounded())
        return round / 100
        
    }
}
