//
//  DateLabeler.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-23.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit

public enum DateLabellingStyle {
    case cautionary //displays as: Open Now, or closes soon, or closed. ... with colors.
    case informative // as 8:00PM
    case objective //as Open or Closed
}

public enum DateUnits {
    case seconds
    case minutes //displays as: Open Now, or closes soon, or closed. ... with colors.
    case hours // as 8:00PM
    case days //as Open or Closed
    case weeks
}

open class DetailDate : NSDate {
    public convenience init(date: String) {
        self.init(dateString: date)/*
        let calendar = Calendar.current
        let hour = calendar.component(.second, from: self as Date)
        let minutes = calendar.component(.minute, from: self as Date)
        let hours = calendar.component(.hour, from: self as Date)
        let day = calendar.component(.day, from: self as Date)*/
    }
}

public enum LocationTimesComponentError: Error {
    case missing(String)
}


open class DateLabeller: UILabel {
    
    private var date : Date?
    private var localTimeString : String?
    private var displayString : String?
    
    open var dynamicStyle: DateLabellingStyle? {
        didSet {
            guard let style = dynamicStyle else {
                return
            }
            switch style {
                case .cautionary:
                    cautionaryParse()
                case .informative:
                    informativeParse()
                case .objective:
                    objectivelyParse()
            }
        }
    }
    
    convenience init(utcString: String) {
        self.init(frame: .zero)
        set(utcString: utcString)
        
    }
    
    convenience init(utcString: String, dynamic: DateLabellingStyle) {
        self.init(utcString: utcString)
        switch dynamic {
        case .cautionary:
            cautionaryParse()
        case .informative:
            informativeParse()
        case .objective:
            objectivelyParse()
        }
    }
    
    private func cautionaryParse() {
        guard let d = date else {
            return
        }
        parseDifferenceInTime { (difference) in
            guard difference >= 0 else {
                return
            }
            self.seconds(time: difference, to: .hours, { (amount, rounded) in
                guard let round = rounded else {
                    return
                }
                guard round else {
                    return
                }
                if amount > 1 {
                    self.displayString = "Closes at "
                } else{
                    
                }
            })
        }
    }
    
    private func informativeParse() {
        parseDifferenceInTime { (difference) in
            guard difference >= 0 else {
                return
            }
            
            if difference == 0 {
                return
            }
            
            
        }
    }
    
    private func objectivelyParse() {
        parseDifferenceInTime { (difference) in
            guard difference >= 0 else {
                return
            }
        }
    }
    
    private func set(utcString: String) {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date1 = dateFormatter.date(from: utcString) else {
            return
        }
        // return the timeZone of your device i.e. America/Los_angeles
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        localTimeString = dateFormatter.string(from: date1)
        
        if let local = localTimeString {
            date = dateFormatter.date(from: local)
        }
    }
    
    private func adaptLabelToDate() {
        
    }
    
    private func parseDifferenceInTime(_ compare: @escaping(_ difference: Double) -> ()) {
        guard let d = date else {
            return
        }
        let diff = Date().compare(d)
        switch diff {
        case .orderedAscending:
            let diff2 = Date().timeIntervalSince(d)
            return compare(diff2)
        case .orderedDescending:
            return compare(-1)
        case .orderedSame:
            return compare(0.0)
        }
    }
    
    func secondParser(time: TimeInterval) {
        
    }
    
    private func seconds(time: TimeInterval, to: DateUnits,_ result: @escaping(_ rounded: Int,_ upwards: Bool?) -> ()) {
        switch to {
        case .seconds:
            let int = Int(time)
            return result(int, nil)
        case .minutes:
            let t = time
            let rem = time.remainder(dividingBy: 60.0)
            if rem > 0.5 {
                return result(Int(ceil(t/60)), true)
            } else {
                return result(Int(floor(t/60)), false)
            }
        case .hours:
            let t = time
            let rem = time.remainder(dividingBy: 3600)
            if rem > 0.5 {
                return result(Int(ceil(t/3600)), true)
            } else {
                return result(Int(floor(t/3600)), false)
            }
        case .days:
            let t = time
            let rem = time.remainder(dividingBy: 86400)
            if rem > 0.5 {
                return result(Int(ceil(t/86400)), true)
            } else {
                return result(Int(floor(t/86400)), false)
            }
        case .weeks:
            let t = time
            let rem = time.remainder(dividingBy: 604800)
            if rem > 0.5 {
                return result(Int(ceil(t/604800)), true)
            } else {
                return result(Int(floor(t/604800)), false)
            }
        }
    }
}
