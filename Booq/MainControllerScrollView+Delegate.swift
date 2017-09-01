//
//  MainControllerScrollView+Delegate.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-05.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

extension MainController : UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func setScrollIndicatorColor(color: UIColor) {
        for view in self.main.subviews {
            if let imageView = view as? UIImageView {
                imageView.changeColorTo(color)
            }
        }
        self.main.flashScrollIndicators()
    }
    
}
