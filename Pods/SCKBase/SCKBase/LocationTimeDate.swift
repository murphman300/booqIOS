//
//  LocationTimeDate.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-24.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation

open class LocationTimeDate : NSObject {
    
    open var comp : LocationTimeComponents?
    open var is_currentDay : Bool? {
        get {
            let now = AcuteTimeValues()
            guard let b = comp, let ngv = now.gregorianValue, let opengv = b.openingVals?.gregorianValue else {
                return nil
            }
            return b.withinTimeFrame && ngv == opengv
        }
    }
    open var open_String: String?
    open var closed_String: String?
    open var closing_soon : Bool?
    open var isClosed : Bool {
        get {
            guard let isnow = is_currentDay else {
                return true
            }
            return !isnow
        }
    }
    open var nowAsGenTime : Int {
        get {
            let now = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: now)
            let min = calendar.component(.minute, from: now)
            let hourHundred = 100 * hour
            let sum = hourHundred + min
            return sum
        }
    }
    
    public init(component: LocationTimeComponents) {
        super.init()
        comp = component
        establishReference()
    }
    
    open func establishReference() {
        guard let component = comp else {
            return
        }
        if component.withinTimeFrame, let opensv = component.closingVals {
            if opensv.summed < AcuteTimeValues().summed - 60 {
                open_String = "Closes at \(opensv.meridiemString)"
            } else {
                closing_soon = true
                open_String = "Closes Soon"
            }
            return
        }
        if component.beforeTimeFrame, let opensv = component.openingVals {
            closed_String = "Opens at \(opensv.meridiemString)"
            return
        }
        if component.afterTimeFrame, let opensv = component.openingVals {
            //so as to force the object to look to second day, we leave all strings nil
            return
        }
    }
    
    func compareTimes(a: AcuteTimeValues, b: AcuteTimeValues) -> Int {
        let hDiff = (a.hours * 60) - (b.hours * 60)
        var totalMins = Int()
        if hDiff < 0 {
            //b is greater..
            totalMins = (((-1) * hDiff) * 60) - a.minutes + b.minutes
        } else if hDiff == 0 {
            totalMins = a.minutes - b.minutes
        } else {
            //a is greater
            totalMins = (hDiff * 60) + a.minutes - b.minutes
        }
        print(totalMins)
        return totalMins
    }
}

extension String {
    public func gregorianValue() -> Int? {
        switch self.lowercased() {
        case "sunday":
            return 1
        case "monday":
            return 2
        case "tuesday":
            return 3
        case "wednesday":
            return 4
        case "thursday":
            return 5
        case "friday":
            return 6
        case "saturday":
            return 7
        default:
            return nil
        }
    }
}

extension Int {
    public func dayFrom() -> String? {
        switch self {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return nil
        }
    }
}
