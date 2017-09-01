//
//  TaxHandler.swift
//  Spotit
//
//  Created by Jean-Louis Murphy on 2017-04-04.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit


open class TaxHandler: NSObject {
    
    public override init() {
        
    }
    
    public func forQuebec(_ amountInCAD: String) -> [String: String] {
        
        let value = CGFloat(Double(amountInCAD)! * 100)
        
        let subtotal = CGFloat(Int((value * CGFloat(1 - CanadianTaxRates.quebec.tps - CanadianTaxRates.quebec.tvq)).rounded()))
        let tps = CGFloat(Int((subtotal * CGFloat(CanadianTaxRates.quebec.tps)))) / 100
        let tvq = CGFloat(Int((subtotal * CGFloat(CanadianTaxRates.quebec.tvq)))) / 100
        let realsub = (CGFloat(value) - CGFloat(Int((subtotal * CGFloat(CanadianTaxRates.quebec.tps)))) - CGFloat(Int((subtotal * CGFloat(CanadianTaxRates.quebec.tvq)))))/100
        
        return ["subtotal": "\(realsub)", "tps": "\(tps)", "tvq": "\(tvq)"]
    }
    
    public func forOntario(_ amountInCAD: String) -> [String: String] {
        
        let value = CGFloat(Double(amountInCAD)! * 100)
        
        let subtotal = CGFloat(Int((value * CGFloat(1 - CanadianTaxRates.ontario.hst)).rounded()))
        let hst = CGFloat(Int((subtotal * CGFloat(CanadianTaxRates.ontario.hst)))) / 100
        let realsub = (CGFloat(value) - CGFloat(Int((subtotal * CGFloat(CanadianTaxRates.ontario.hst)))))/100
        
        return ["subtotal": "\(realsub)", "hst": "\(hst)"]
    }
    
}
