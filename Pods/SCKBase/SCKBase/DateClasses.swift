//
//  DateClasses.swift
//  Checkout
//
//  Created by Jean-Louis Murphy on 2017-01-23.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation

open class ADate: DOB {
    
    required convenience public init(day: String, month: String, year: String) {
        self.init()
        self.day.set(day)
        self.month.set(month)
        self.year.set(year)
        self.start()
    }
    
    public func setFrom(string: String) {
        
        let dat = string.components(separatedBy: "T")
        let da = dat[0]
        
        guard da.characters.count == 10 else {
            return
        }
        let comps = da.components(separatedBy: "-")
        guard comps[0].characters.count == 4 else {
            return
        }
        guard comps[1].characters.count == 2 && comps[2].characters.count == 2 else {
            return
        }
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        if let d = dateStringFormatter.date(from: da) {
            //let d = NSDate().timeIntervalSince(d)
            self.date = d as Date
        }
    }
    
    
    deinit {
        
    }
}


extension NSDate {
    public func dateString(str: String) {
        
        
        guard str.characters.count == 10 else {
            return
        }
        let comps = str.components(separatedBy: "-")
        guard comps[0].characters.count == 4 else {
            return
        }
        guard comps[1].characters.count == 2 && comps[2].characters.count == 2 else {
            return
        }
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        if let d = dateStringFormatter.date(from: str) {
            timeIntervalSince(d)
        }
    }
    convenience public init(dateString: String) {
        self.init()
        guard !dateString.contains("Z") else {
            let dateFormatter = DateFormatter()
            let ot = dateString.components(separatedBy: ".")[0]+"Z"
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            guard let date = dateFormatter.date(from:ot) else {
                return
            }
            timeIntervalSince(date)
            return
        }
        guard dateString.characters.count == 10 else {
            return
        }
        let comps = dateString.components(separatedBy: "-")
        guard comps[0].characters.count == 4 else {
            return
        }
        guard comps[1].characters.count == 2 && comps[2].characters.count == 2 else {
            return
        }
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        if let d = dateStringFormatter.date(from: dateString) {
            timeIntervalSince(d)
        }
    }
    
}
