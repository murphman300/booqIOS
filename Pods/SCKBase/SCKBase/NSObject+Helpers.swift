//
//  NSObject+Helpers.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit

public extension NSObject {
    
    public func codeFor(countryName: String) -> String {
        let locales : String = ""
        for localeCode in NSLocale.isoCountryCodes {
            let countryName = Locale.current.regionCode
            if countryName?.lowercased() == countryName?.lowercased() {
                return localeCode
            }
        }
        return locales
    }
    
    public func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    public func floatValueW(cgfloat: CGFloat) -> CGFloat{
        var result = CGFloat()
        if let window = UIApplication.shared.keyWindow {
            
            result = window.frame.width * (cgfloat / 375)
            
        }
        return result
    }
    
    public func floatValueH(cgfloat: CGFloat) -> CGFloat{
        var result = CGFloat()
        if let window = UIApplication.shared.keyWindow {
            
            result = window.frame.width * (cgfloat / 667)
            
        }
        return result
    }
    
}
