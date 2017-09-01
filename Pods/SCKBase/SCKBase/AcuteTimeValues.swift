//
//  AcuteTimeValues.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-24.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit


public struct AcuteTimeValues {
    
    public var gregorianValue : Int?
    public var gregorianDay : Int?
    public var gregorian : Int
    public var hours : Int
    public var minutes : Int
    public var summed : Int
    public var meridiemString: String
    
    public init(from: Int, meridiem: Bool) {
        let doub = Double(from)
        let hours = Int(floor(doub / 100))
        let mins = from - (hours * 100)
        var st = "\(hours):"
        var minSt = "\(mins)"
        if Int(hours) == 0 {
            st = "0" + st
        }
        if minSt.characters.count == 1 {
            minSt = "0" + minSt
        }
        if meridiem {
            meridiemString = (hours < 12) ? st + "\(minSt)AM" : st + "\(minSt)PM"
        } else {
            meridiemString = st + "\(mins)"
        }
        gregorian = from
        self.hours = hours
        minutes = mins
        summed = (hours * 60) + minutes
    }
    
    public init(asClosed gregorian: Int) {
        self.gregorian = gregorian
        hours = 0
        minutes = 0
        summed = 0
        meridiemString = "Closed"
    }
    
    public init() {
        let now = Date()
        let cal = Calendar.current
        let hrs = cal.component(.hour, from: now) * 100
        let mins = cal.component(.minute, from: now)
        self.init(from: hrs + mins, meridiem: true)
        self.gregorianValue = cal.component(.weekday, from: now)
    }
    
    public var hasPast : Bool {
        get {
            let now = AcuteTimeValues()
            return now >= self
        }
    }
    
    func asCurrentTo(closing: AcuteTimeValues) -> Int {
        guard let value = self.gregorianValue, let closev = closing.gregorianValue else {
            return -1
        }
        if value == closev - 1 {
            return differenceToNextDayTime(dayB: closing)
        } else if value == closev {
            return differenceTo(b: closing)
        } else {
            return 2500
        }
    }
    
    func differenceAsCurrentTo(opening: AcuteTimeValues) -> Int {
        if ((opening.summed / 60) < 4) {
            let diff = differenceTo(b: opening)
            if diff <= 4 {
                return diff
            } else {
                return differenceToNextDayTime(dayB: opening)
            }
        } else {
            return differenceTo(b: opening)
        }
    }
    
    func differenceToNextDayTime(dayB: AcuteTimeValues) -> Int {
        let minsInA = (60 * 24) - self.summed
        return dayB.summed + minsInA
    }
    
    func differenceTo(b: AcuteTimeValues) -> Int {
        let t = b.summed - self.summed
        return b.summed - self.summed
    }
}

extension AcuteTimeValues: Equatable {
    
    public static func < (lhs: AcuteTimeValues, rhs: AcuteTimeValues) -> Bool {
        if let greg1 = lhs.gregorianDay, let greg2 = rhs.gregorianDay {
            if greg1 == 0 && greg2 == 1 {
                return lhs.differenceToNextDayTime(dayB: rhs) > 0
            } else {
                return rhs.differenceToNextDayTime(dayB: lhs) > 0
            }
        } else if let lv = lhs.gregorianValue, let rv = rhs.gregorianValue {
            guard !(lv == 1 && rv == 7) && !(lv == 7 && rv == 1) else {
                guard (lv == 1 && rv == 7) else {
                    return true
                }
                return false
            }
            if lv == rv {
                return lhs.summed < rhs.summed
            } else if lv > rv {
                return false
            } else {
                return true
            }
        } else {
            return lhs.summed < rhs.summed
        }
    }
    public static func > (lhs: AcuteTimeValues, rhs: AcuteTimeValues) -> Bool {
        if let greg1 = lhs.gregorianDay, let greg2 = rhs.gregorianDay {
            if greg1 == 0 && greg2 == 1 {
                return lhs.differenceToNextDayTime(dayB: rhs) < 0
            } else {
                return rhs.differenceToNextDayTime(dayB: lhs) < 0
            }
        } else if let lv = lhs.gregorianValue, let rv = rhs.gregorianValue {
            guard !(lv == 1 && rv == 7) && !(lv == 7 && rv == 1) else {
                guard (lv == 1 && rv == 7) else {
                    return false
                }
                return true
            }
            if lv == rv {
                return lhs.summed > rhs.summed
            } else if lv > rv {
                return true
            } else {
                return false
            }
        } else {
            return lhs.summed > rhs.summed
        }
    }
    public static func == (lhs: AcuteTimeValues, rhs: AcuteTimeValues) -> Bool {
        if let greg1 = lhs.gregorianDay, let greg2 = rhs.gregorianDay {
            if greg1 == 0 && greg2 == 1 {
                return lhs.differenceToNextDayTime(dayB: rhs) == 0
            } else {
                return rhs.differenceToNextDayTime(dayB: lhs) == 0
            }
        } else if let lv = lhs.gregorianValue, let rv = rhs.gregorianValue {
            guard !(lv == 1 && rv == 7) && !(lv == 7 && rv == 1) else {
                guard (lv == 1 && rv == 7) else {
                    return false
                }
                return false
            }
            if lv == rv {
                return lhs == rhs
            } else if lv > rv {
                return false
            } else {
                return false
            }
        } else {
            return lhs.summed == rhs.summed
        }
    }
    public static func <= (lhs: AcuteTimeValues, rhs: AcuteTimeValues) -> Bool {
        if let greg1 = lhs.gregorianDay, let greg2 = rhs.gregorianDay {
            if greg1 == 0 && greg2 == 1 {
                return lhs.differenceToNextDayTime(dayB: rhs) >= 0
            } else {
                return rhs.differenceToNextDayTime(dayB: lhs) >= 0
            }
        } else if let lv = lhs.gregorianValue, let rv = rhs.gregorianValue {
            guard !(lv == 1 && rv == 7) && !(lv == 7 && rv == 1) else {
                guard (lv == 1 && rv == 7) else {
                    return true
                }
                return false
            }
            if lv == rv {
                return lhs < rhs || lhs == rhs
            } else if lv > rv {
                return false
            } else {
                return true
            }
        } else {
            if lhs.summed == rhs.summed || lhs.summed < rhs.summed {
                return true
            } else {
                return false
            }
        }
    }
    public static func >= (lhs: AcuteTimeValues, rhs: AcuteTimeValues) -> Bool {
        if let greg1 = lhs.gregorianDay, let greg2 = rhs.gregorianDay {
            if greg1 == 0 && greg2 == 1 {
                return lhs.differenceToNextDayTime(dayB: rhs) <= 0
            } else {
                return rhs.differenceToNextDayTime(dayB: lhs) <= 0
            }
        } else if let lv = lhs.gregorianValue, let rv = rhs.gregorianValue {
            guard !(lv == 1 && rv == 7) && !(lv == 7 && rv == 1) else {
                guard (lv == 1 && rv == 7) else {
                    return false
                }
                return true
            }
            if lv == rv {
                return lhs > rhs || lhs == rhs
            } else if lv > rv {
                return true
            } else {
                return false
            }
        } else {
            if lhs.summed == rhs.summed || lhs.summed > rhs.summed {
                return true
            } else {
                return false
            }
        }
    }
}

