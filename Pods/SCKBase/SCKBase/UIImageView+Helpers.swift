//
//  UIImageView+Helpers.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit

public extension UIImageView {
    
    public func changeColorTo(_ color: UIColor) {
        if let imageToChange = image?.withRenderingMode(.alwaysTemplate) {
            image = imageToChange
            tintColor = color
        }
    }
    
}
