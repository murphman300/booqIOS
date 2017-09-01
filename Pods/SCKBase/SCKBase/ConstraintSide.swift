//
//  ConstraintSide.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-07-09.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit

public enum ConstraintSide : Int {
    case top = 0, bottom = 1, left = 2, right = 3, height = 4, width = 5, x = 6, y = 7
}

extension ConstraintSide {
    static public func all() -> AnySequence<ConstraintSide> {
        return AnySequence {
            return SectionsGenerator()
        }
    }
    
    public struct SectionsGenerator: IteratorProtocol {
        public var currentSection = 0
        
        mutating public func next() -> ConstraintSide? {
            guard let item = ConstraintSide(rawValue:currentSection) else {
                return nil
            }
            currentSection += 1
            return item
        }
    }
    
}
