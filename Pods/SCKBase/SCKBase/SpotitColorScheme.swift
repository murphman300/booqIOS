//
//  SpotitColorScheme.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-23.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit

public struct SpotitColorScheme {
    public var background : UIColor
    public var border : UIColor
    public var isSelected : UIColor?
    public var isHighlighted : UIColor?
    public var titleColor : UIColor?
    
    public init(background : UIColor, border : UIColor, titleColor: UIColor?, isSelected : UIColor?, isHighlighted : UIColor?) {
        self.background = background
        self.border = border
        self.isSelected = isSelected
        self.isHighlighted = isHighlighted
        self.titleColor = titleColor
    }
}
