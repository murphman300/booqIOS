//
//  NSLocale+Helpers.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit

extension NSLocale
{
    open class func localeForCountry(countryName : String) -> String?
    {
        return NSLocale.isoCountryCodes.filter{self.countryNameFromLocaleCode(localeCode: $0) == countryName}.first! as String
    }
    
    open class func countryNameFromLocaleCode(localeCode : String) -> String
    {
        return NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.countryCode, value: localeCode) ?? ""
    }
}
