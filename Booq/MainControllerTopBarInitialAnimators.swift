//
//  MainControllerTopBarInitialAnimators.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-23.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

extension MainController {
    
    func makeLoading() {
        view.bringSubview(toFront: appLogo)
        loading.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let w = loading.frame.width - 110
        let h = w / 2
        appLogo.frame.size = CGSize(width: w, height: h)
        appLogo.center.x = view.frame.width / 2
        appLogo.center.y = view.frame.height / 2
        appLogo.image = #imageLiteral(resourceName: "booqAppTestLargeCursive")
        appLogo.contentMode = .scaleAspectFit
    }
    
    func changeTopBarFromInitial() {
        let h = buttonSizes.mainheight * 1.1
        appLogo.frame.size = CGSize(width: h * 2, height: h)
        appLogo.center.x = view.frame.width / 2
        appLogo.center.y = (top.frame.height / 2) + 20
        loading.alpha = 0
    }
    
    func reapplyLogoPic() {
        appLogo.image = #imageLiteral(resourceName: "booqAppTextCursive")
        appLogo.contentMode = .scaleAspectFit
    }
    
}
