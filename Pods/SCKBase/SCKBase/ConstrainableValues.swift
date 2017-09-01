//
//  ConstrainableValues.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-08-06.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit


public enum ConstrainableElementType {
    case button
    case view
    case imageView
    case label
    case textField
}

public enum ConstraintElement: Int{
    case top = 0
    case bottom = 1
    case left = 2
    case right = 3
    case vertical = 4
    case horizontal = 5
    case height = 6
    case width = 7
}

public enum ConstraintAxis: Int {
    case top = 0
    case bottom = 1
    case left = 2
    case right = 3
    case vertical = 4
    case horizontal = 5
    
    public var element: ConstraintElement {
        return ConstraintElement(rawValue: self.rawValue)!
    }
}

public enum ConstraintXAxis : Int {
    
    case left = 2
    case right = 3
    case horizontal = 5
    
    public var element: ConstraintElement {
        return ConstraintElement(rawValue: self.rawValue)!
    }
}

public enum ConstraintYAxis : Int {
    
    case top = 0
    
    case bottom = 1
    
    case vertical = 4
    
    public var element: ConstraintElement {
        return ConstraintElement(rawValue: self.rawValue)!
    }
}

public enum ConstraintDimension: Int {
    
    case height = 6
    
    case width = 7
    
    public var element: ConstraintElement {
        return ConstraintElement(rawValue: self.rawValue)!
    }
}
