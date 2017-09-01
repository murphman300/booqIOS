//
//  MainControllerMenu+Methods.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-30.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

extension MainController: MenuControllerDelegate {
    
    func menuPresenter() {
        let menu = MenuViewController()
        menu.modalPresentationStyle = .overCurrentContext
        menu.delegate = self
        self.present(menu, animated: true) {
            UIView.animate(withDuration: 0.4, animations: {
                self.appLogo.alpha = 0
                self.leftBut.alpha = 0
            }, completion: { (v) in
                
            })
            UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseIn, animations: {
                self.statusBarStyle = .default
                self.setNeedsStatusBarAppearanceUpdate()
            }, completion: { (v) in
                
            })
        }
    }
    
    func menu(controller: MenuViewController, didClose: Bool) {
        if didClose {
            controller.delegate = nil
        }
    }
    
    func menu(controller: MenuViewController, isClosing: Bool) {
        self.statusBarStyle = .lightContent
        UIView.animate(withDuration: 0, delay: 0.35, options: .curveEaseIn, animations: {
            self.appLogo.alpha = 1
            self.leftBut.alpha = 1
            self.setNeedsStatusBarAppearanceUpdate()
        }) { (v) in
            
        }
    }
    
}
