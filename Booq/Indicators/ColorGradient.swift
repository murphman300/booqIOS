//
//  ColorGradient.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-29.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit
import CoreGraphics

extension CGFloat {
    var double : Double {
        return Double(self)
    }
}

extension Double {
    var cgFloat : CGFloat {
        return CGFloat(self)
    }
}

enum PercentageCoordinates {
    
    case noon
    case three
    case six
    case nine
    case other(CGPoint)
    
    init() {
        self = .nine
    }
    
    init(value: CGPoint) {
        let t = PercentageCoordinate(rawValue: value)
        if t == PercentageCoordinate.nine {
            self = .nine
        } else if t == PercentageCoordinate.six {
            self = .six
        } else if t == PercentageCoordinate.three {
            self = .three
        } else if t == PercentageCoordinate.noon {
            self = .noon
        } else {
            self = .other(value)
        }
    }
    
}

class PercentageCoordinate : Equatable {
    
    typealias StringLiteralType = Swift.String
    
    var rawValue: CGPoint = .zero
    
    typealias RawValue = CGPoint
    
    var x : CGFloat = 0
    
    var y : CGFloat = 0
    
    static let noon = PercentageCoordinate(rawValue: CGPoint(x: 0, y: 1))
    static let three = PercentageCoordinate(rawValue: CGPoint(x: 1, y: 0))
    static let six = PercentageCoordinate(rawValue: CGPoint(x: 0, y: -1))
    static let nine = PercentageCoordinate(rawValue: CGPoint(x: -1, y: 0 ))
    
    required init(rawValue: CGPoint) {
        if rawValue.x <= 1 || rawValue.y <= 1 || rawValue.y >= -1 || rawValue.x >= -1 {
            self.x = rawValue.x
            self.y = rawValue.y
        }
    }
    
    static func !=(lhs: PercentageCoordinate, rhs: PercentageCoordinate) -> Bool {
        return lhs.x != rhs.x || lhs.y != rhs.y
    }
    
    static func ==(lhs: PercentageCoordinate, rhs: PercentageCoordinate) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

class Percentage {
    
    private var pi = Double.pi
    
    private var circlePI : Double {
        return Double.pi * 2
    }
    
    private var _pastPercent : Double = 0
    
    private var _percent: Double = 0
    
    var origin : PercentageCoordinates
    
    var percent : Double {
        return _percent
    }
    
    var pastPercent : Double {
        return _pastPercent
    }
    
    private var clockwise : Bool = true
    
    required init() {
        _pastPercent = 0
        _percent = 0
        origin = .nine
    }
    
    convenience init(value: Int) {
        self.init()
        if value <= 100 {
            let d = Double(value)
            _pastPercent = d
            _percent = d
        }
    }
    
    convenience init(value: Int, origin: CGPoint) {
        self.init(value: value)
        self.origin = PercentageCoordinates(value: origin)
    }
    
    convenience init(value: Double) {
        self.init()
        if value <= 1.0 {
            _pastPercent = value
            _percent = value
        }
    }
    
    convenience init(value: Double, origin: CGPoint) {
        self.init(value: value)
        self.origin = PercentageCoordinates(value: origin)
    }
    
    convenience init(value: CGFloat) {
        self.init()
        if value <= 1.0 {
            let d = Double(value)
            _pastPercent = d
            _percent = d
        }
    }
    
    convenience init(value: CGFloat, origin: CGPoint) {
        self.init(value: value)
        self.origin = PercentageCoordinates(value: origin)
    }
    //when Applying an origin of the percentage
    convenience init(origin: CGPoint, clockwise: Bool) {
        self.init(value: 0.0)
        self.clockwise = clockwise
        self.origin = PercentageCoordinates(value: origin)
    }
    
    private func startFromOriginForEndAngle() -> CGFloat {
        let transition = transitionPercentage.cgFloat
        let start = (_pastPercent * circlePI).cgFloat
        if clockwise {
            switch origin {
            case .noon:
                return (pi / Double(2)).cgFloat + start + transition
            case .three:
                return start + transition
            case .six:
                let new = (pi * Double(3.0)).cgFloat
                return new - (start + transition)
            case .nine:
                return pi.cgFloat + start + transition
            case .other(let point):
                if point.y == 0 {
                    if point.x == 1 {
                        return start + transition
                    } else {
                        return pi.cgFloat + start + transition
                    }
                } else {
                    let tangent = tan(point.x / point.y)
                    return tangent + start + transition
                }
            }
        } else {
            switch origin {
            case .noon:
                return (pi / Double(2)).cgFloat - start - transition
            case .three:
                return start + transition
            case .six:
                let new = (pi * Double(3.0)).cgFloat
                return new - start - transition
            case .nine:
                return pi.cgFloat + start + transition
            case .other(let point):
                if point.y == 0 {
                    if point.x == 1 {
                        return start + transition
                    } else {
                        return pi.cgFloat + start + transition
                    }
                } else {
                    let tangent = tan(point.x / point.y)
                    return tangent + start + transition
                }
            }
        }
    }
    
    var transitionPercentage : Double {
        return circlePI * (_percent - _pastPercent)
    }
    
    var startAndEndAngles : (Double,Double) {
        return (circlePI * _pastPercent, circlePI * _percent)
    }
    
    var cgStartAndEndAngles : (CGFloat,CGFloat) {
        return (CGFloat(circlePI * _pastPercent), CGFloat(circlePI * _percent))
    }
    
    func modify(_ value: Double) {
        if value > 1.0 || value < 0.0 {
            return
        }
        _pastPercent = _percent
        _percent = value
    }
    
    func mod(_ value: Double) -> Percentage {
        guard value > 1.0 || value < 0.0 else {
            return self
        }
        _pastPercent = _percent
        _percent = value
        return self
    }
    
}

class ColorGradient {
    
    var colors = [UIColor]()
    
    init(colors: UIColor...) {
        self.colors = colors
    }
    
    var gradientLayer : CAGradientLayer {
        let l = CAGradientLayer()
        print(colors)
        for c in colors {
            l.colors?.append(c.cgColor as AnyObject)
        }
        return l
    }
    
    var onlyColors : [CGColor] {
        var cols : [CGColor] = []
        for c in colors {
            cols.append(c.cgColor)
        }
        return cols
    }
    
}

