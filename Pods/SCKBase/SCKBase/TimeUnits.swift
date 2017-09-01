//
//  TimeUnits.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-24.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//


import UIKit

public struct TimeUnits {
    public struct days {
        public static let inAWeek : Int = 7
    }
    public struct hours {
        public static let inADay : Int = 24
        public static let inAWeek : Int = inADay * days.inAWeek
    }
    public struct minutes {
        static let inAnHour: Int = 60
        static let inADay : Int = inAnHour * 60
        static let inAWeek : Int = inADay * days.inAWeek
    }
    public struct seconds {
        public static let inAMinute : Int = 60
        public static let inAnHour : Int = minutes.inAnHour * inAMinute
        public static let inADay : Int = inAnHour * hours.inADay
        public static let inAWeek : Int = inADay * days.inAWeek
    }
    public struct milliseconds {
        public static let inASecond : Int = 1000
        public static let inAMinute : Int = inASecond * seconds.inAMinute
        public static let inAnHour : Int = minutes.inAnHour * inAMinute
        public static let inADay : Int = inAnHour * hours.inADay
        public static let inAWeek : Int = inADay * days.inAWeek
    }
}

