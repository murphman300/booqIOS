//
//  ContrastBackground.swift
//  Spotit
//
//  Created by Jean-Louis Murphy on 2017-04-05.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit


open class ContrastBackground {
    var fadeFrom = UIColor()
    var toColor = UIColor()
    var fadeAt = [CGFloat]()
    var side : ContrastSide?
    
    public convenience init(_ startFrom: ContrastSide,_ fadeFrom: UIColor,_ toColor: UIColor,_ fadeAt: [CGFloat]) {
        self.init()
        self.fadeFrom = fadeFrom
        self.toColor = toColor
        self.side = startFrom
        self.fadeAt = fadeAt
    }
}
