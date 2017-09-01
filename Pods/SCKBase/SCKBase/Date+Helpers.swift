//
//  Date+Helpers.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit

extension Date {
    
    
    public func dateFrom(string: String) -> Date? {
        guard string.characters.count == 10 else { return nil }
        let comps = string.components(separatedBy: "-")
        guard comps[0].characters.count == 4 else { return nil }
        guard comps[1].characters.count == 2 && comps[2].characters.count == 2 else { return nil }
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        guard let d = dateStringFormatter.date(from: string) else { return nil }
        return d
    }
    
    public func dateFrom(utcString: String) -> Date? {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        guard let d = dateStringFormatter.date(from: utcString) else { return nil }
        return d
    }
    
    public func hasPast() -> Bool {
        //true if within time frame, false if beyond time frame
        let todaysDate = NSDate()
        var value = Int()
        var result = Bool()
        if #available(iOS 10.0, *) {
            var diffDateComponents = NSCalendar.current.dateComponents([Calendar.Component.second], from: todaysDate as Date, to: self)
            value = diffDateComponents.second!
            if value <= 0 {
                result = true
            } else {
                result = false
            }
        } else {
            var diffDateComponents = NSCalendar.current.dateComponents([Calendar.Component.second], from: todaysDate as Date, to: self)
            value = diffDateComponents.second!
            if value <= 0 {
                result = true
            } else {
                result = false
            }
        }
        return result
    }
    
}

