//
//  TimeComponents.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-24.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit


open class LocationTimeComponents : NSObject {
    
    public var is_open : Bool
    public var opening : Int?
    public var openingVals : AcuteTimeValues?
    public var closing : Int?
    public var closingVals : AcuteTimeValues?
    public var timezone : String?
    public var weekday : String?
    public var gregorian : Int?
    
    public init(info: [String:Any]) throws {
        if let isOp = info["is_open"] as? Bool {
            self.is_open = isOp
            super.init()
            if isOp {
                if let closing = info["timezone"] as? String {
                    self.timezone = closing
                } else {
                    throw LocationTimesComponentError.missing("No timezone")
                }
                if let weekd = info["weekday"] as? String{
                    self.weekday = weekd
                    if let close = info["closing"] as? Int, let open = info["opening"] as? Int, let int = weekd.gregorianValue() {
                        self.gregorian = int
                        self.closing = close
                        self.opening = open
                        openingVals = AcuteTimeValues(from: open, meridiem: true)
                        closingVals = AcuteTimeValues(from: close, meridiem: true)
                        if close < open {
                            openingVals?.gregorianDay = 0
                            closingVals?.gregorianDay = 1
                            if int <= 6 {
                                closingVals?.gregorianValue = int + 1
                                openingVals?.gregorianValue = int
                            } else {
                                closingVals?.gregorianValue = 1
                                openingVals?.gregorianValue = 7
                            }
                        } else {
                            closingVals?.gregorianValue = int
                            openingVals?.gregorianValue = int
                        }
                    } else {
                        throw LocationTimesComponentError.missing("No closing")
                    }
                } else {
                    throw LocationTimesComponentError.missing("No weekday")
                }
            } else {
                if let weekd = info["weekday"] as? String{
                    self.weekday = weekd
                    if let int = weekd.gregorianValue() {
                        self.gregorian = int
                    } else {
                        throw LocationTimesComponentError.missing("No closing")
                    }
                } else {
                    throw LocationTimesComponentError.missing("No weekday")
                }
            }
        } else {
            throw LocationTimesComponentError.missing("No Status")
        }
    }
    
    open var withinTimeFrame : Bool {
        if let openings = openingVals, let closings = closingVals {
            let now = AcuteTimeValues()
            let op = now > openings
            let ap = now < closings
            return op && ap
        } else {
            return false
        }
    }
    
    open var beforeTimeFrame : Bool {
        if let openings = openingVals{
            let now = AcuteTimeValues()
            return now < openings
        } else {
            return false
        }
    }
    
    open var afterTimeFrame : Bool {
        if let closings = closingVals {
            let now = AcuteTimeValues()
            return now > closings
        } else {
            return false
        }
    }
    
    open var placeTimeToClose: ReferenceToLocationTimeComponent {
        if withinTimeFrame, let c = closingVals {
            if AcuteTimeValues().asCurrentTo(closing: c) <= 60 {
                return .withinHour
            } else {
                return .beyondHour
            }
        } else if afterTimeFrame {
            return .passed
        } else {
            return .beyondHour
        }
    }
    
    open var placeTimeToOpening: ReferenceToLocationTimeComponent {
        if beforeTimeFrame, let c = openingVals {
            if AcuteTimeValues().differenceAsCurrentTo(opening: c) <= 60 {
                return .withinHour
            } else {
                return .beyondHour
            }
        } else {
            return .passed
        }
    }
    
    open var currentLabel : String {
        if let op = openingVals, let cp = closingVals {
            if withinTimeFrame {
                return "Open until \(cp.meridiemString)"
            } else if beforeTimeFrame {
                return "Opens at \(op.meridiemString)"
            } else {
                return "next day"
            }
        } else {
            return "Closed"
        }
    }
}

public enum SelectLocationTimeComponent {
    case beforeTimes
    case afterTimes
    case withinTimes
}

public enum ReferenceToLocationTimeComponent {
    case withinHour
    case beyondHour
    case passed
}
