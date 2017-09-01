//
//  MenuViewControllerCellDelegate.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-30.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

extension MenuViewController: MenuCellDelegate, LicenseListingDelegate, SelectorViewPanningDelegate {
    
    
    func selector(view: SelectorView, didPan: CGFloat) {
        let alpha = didPan / (view.frame.width / 2)
        let half = view.frame.width / 2
        if let select = selection, view == select {
            self.listing.center.x = (half * alpha) - half
            self.listing.alpha = alpha
            self.leftBut.alpha = alpha
            self.appLogo.alpha = alpha
            self.topSelection.alpha = 1 - alpha
            self.topSelection.center.x = (self.view.frame.width * 0.5) + (self.view.frame.width * 0.4 * alpha)
        } else if let lic = license, view == lic {
            self.selection?.center.x = (half * alpha) - half
            self.selection?.alpha = alpha
            self.selectedTitle.alpha = alpha
            self.secondSelectedTitle.alpha = 1 - alpha
            self.secondSelectedTitle.center.x = (self.view.frame.width * 0.5) + (self.view.frame.width * 0.4 * alpha)
        }
    }
    
    func selector(view: SelectorView, dismissed: Bool, with: CGFloat) {
        guard dismissed else {
            UIView.animate(withDuration: 0.4 * Double(with), animations: {
                if view == self.selection {
                    self.listing.center.x = 0
                    self.listing.alpha = 0
                    self.leftBut.alpha = 0
                    self.appLogo.alpha = 0
                    self.topSelection.alpha = 1
                    self.topSelection.center.x = view.frame.width / 2
                } else if let lic = self.license, view == lic {
                    self.selection?.center.x = 0
                    self.selection?.alpha = 0
                    self.selectedTitle.alpha = 0
                    self.secondSelectedTitle.alpha = 1
                    self.secondSelectedTitle.center.x = view.frame.width / 2
                }
            })
             return
        }
        UIView.animate(withDuration: 0.4 * Double(with), animations: {
            if view == self.selection {
                self.topSelection.center.x = self.view.frame.width * 0.9
                self.listing.center.x = self.view.frame.width / 2
                self.listing.alpha = 1
                self.leftBut.alpha = 1
                self.appLogo.alpha = 1
                self.topSelection.alpha = 0
            } else if let lic = self.license, view == lic {
                self.selection?.center.x = self.view.frame.width / 2
                self.selection?.alpha = 1
                self.secondSelectedTitle.alpha = 0
                self.secondSelectedTitle.center.x = self.view.frame.width * 0.75
                self.selectedTitle.alpha = 1
            }
        }) { (v) in
            if view == self.selection {
                self.selection?.alpha = 0
                self.selection?.removeFromSuperview()
                self.selection = nil
            } else if let lic = self.license, view == lic {
                self.license?.alpha = 0
                self.license?.removeFromSuperview()
                self.license = nil
            }
        }
    }
    
    func menu(cell: MenuCell, wasSelected with: AllMenuCells) {
        
        selectedTitle.text = with.value
        
        switch with {
        case .terms:
            selection = HTMLView(frame: CGRect(x: view.frame.width, y: newH, width: view.frame.width, height: listing.frame.height))
            container.addSubview(selection!)
            (selection as? HTMLView)?.path = "termsBooq"
            showSelection()
        case .privacy:
            selection = HTMLView(frame: CGRect(x: view.frame.width, y: newH, width: view.frame.width, height: listing.frame.height))
            container.addSubview(selection!)
            (selection as? HTMLView)?.path = "ppvcy"
            showSelection()
        case .licenses:
            selection = LicenseListings(frame: CGRect(x: view.frame.width, y: newH, width: view.frame.width, height: listing.frame.height))
            container.addSubview(selection!)
            (selection as? LicenseListings)?.licenseDelegate = self
            showSelection()
        case .agreement:
            selection = HTMLView(frame: CGRect(x: view.frame.width, y: newH, width: view.frame.width, height: listing.frame.height))
            container.addSubview(selection!)
            (selection as? HTMLView)?.path = "booqBetaGuide"
            showSelection()
        default:
            break
        }
        
    }
    
    func license(cell: LicenseListingCell, wasPressed: Bool, with: AppLicense) {
        license = LicenseView(frame: CGRect(x: view.frame.width, y: top.frame.maxY, width: view.frame.width, height: listing.frame.height))
        license?.license = with
        license?.alpha = 1
        secondSelectedTitle.text = with.title
        license?.delegate = self
        container.addSubview(license!)
        showLicense()
    }
    
    func showLicense() {
        guard let lic = license else { return }
        UIView.animate(withDuration: 0.3, animations: {
            self.selection?.center.x = 0
            self.selection?.alpha = 0
            self.secondSelectedTitle.alpha = 1
            self.secondSelectedTitle.center.x = self.view.frame.width / 2
            self.selectedTitle.alpha = 0
            lic.center.x = self.view.frame.width / 2
            lic.alpha = 1
        }) { (v) in
            
        }
    }
    
    func hideLicense() {
        guard let lic = license else { return }
        UIView.animate(withDuration: 0.3, animations: {
            self.selection?.center.x = self.view.frame.width / 2
            self.selection?.alpha = 1
            self.secondSelectedTitle.alpha = 0
            self.secondSelectedTitle.center.x = self.view.frame.width * 0.75
            self.selectedTitle.alpha = 1
            lic.center.x = self.view.frame.width * 1.5
            lic.alpha = 0
        }) { (v) in
            self.secondSelectedTitle.text = nil
            lic.removeFromSuperview()
            self.license = nil
        }
    }
    
    func showSelection() {
        guard let select = selection else { return }
        select.alpha = 1
        UIView.animate(withDuration: 0.35, animations: {
            select.center.x = self.view.frame.width / 2
            self.listing.center.x = 0
            self.listing.alpha = 0
            self.topSelection.center.x = self.view.frame.width / 2
            self.topSelection.alpha = 1
            self.leftBut.alpha = 0
            self.appLogo.alpha = 0
        }) { (v) in
            self.selection?.delegate = self
        }
    }
    
    func backToMain() {
        if license != nil {
            hideLicense()
        } else {
            guard let select = selection else { return }
            UIView.animate(withDuration: 0.3, animations: {
                self.topSelection.center.x = self.view.frame.width * 0.9
                self.listing.center.x = self.view.frame.width / 2
                self.listing.alpha = 1
                self.leftBut.alpha = 1
                self.appLogo.alpha = 1
                self.topSelection.alpha = 0
                self.selection?.center.x = self.view.frame.width * 1.5
                self.selection?.alpha = 0
            }) { (v) in
                self.selection?.removeFromSuperview()
                self.selection = nil
            }
        }
    }
    
}
