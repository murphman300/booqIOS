//
//  MainControllerContactCellDelegate.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-04.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase
import MapKit

var profileAction : ActionProfile?

extension MainController : ContactCellDelegate, HybridActionProtocol, ContactCellActionDelegate {
    
    
    func action(profile: ActionProfile, shouldResize count: Int, from: CGSize, withNew: ((CGSize?)->(Bool))?) {
        guard profileAction != nil else {
            if let t = withNew {
                _ = t(nil)
            }
            return
        }
        guard let new = withNew else { return }
        DispatchQueue.main.async {
            profileAction?.frame.size = from
            profileAction?.center.x = self.view.frame.width / 2
            profileAction?.center.y = self.view.frame.height - (from.height / 2) + (profileAction?.layer.cornerRadius)!
            profileAction?.alpha = 0
            profileAction?.layoutIfNeeded()
            if new(from) {
                DispatchQueue.main.async {
                    self.opaqueView?.alpha = 0
                    if let edit = self.addContact {
                        edit.closeFromDelete({
                            profileAction?.removeFromSuperview()
                            profileAction = nil
                            self.opaqueView?.removeFromSuperview()
                        })
                    }
                }
            } else {
                //Is not deleting
                profileAction?.alpha = 1
            }
        }
        
    }

    func action(profile: ActionProfile, selected: ActionButton, with: Contact, atIndexPath: IndexPath) {
        guard let act = selected.attributes else {
            return
        }
        if let call = act[ContactActionValues.call.rawValue] as? PhoneNumber {
            predicateAppURL("tel://" + call.compact)
        }
        if let sms = act[ContactActionValues.sms.rawValue] as? PhoneNumber {
            predicateAppURL("sms:\(sms.compact)&body=\("Hello")")
        }
        if let email = act[ContactActionValues.email.rawValue] as? Email {
            if !predicateURL("googlegmail:///co?subject=\(with.name)&body=Hello&to=\(email.value)") {
                predicateAppURL("message:///mailto:\(email.value)")
            }
        }
        if let loc = act[ContactActionValues.loc.rawValue] as? PostalCode, let compact = loc.compact {
            if !predicateURL("comgooglemaps://?q=\(compact)") {
                predicateAppURL("http://maps.apple.com/?q=\(compact)")
            }
        }
        if let cont = act[ContactActionValues.profile.rawValue] as? Contact {
            let corn = ModalCornerLayout.topBoth(10)
            let layouts = LayoutDiferences(top: 0, bottom: nil, corners: corn)
            let options = ModalViewControllerLayoutOptions(at: .visible, appear: .animation, relativeTo: .bottom, layed: layouts)
            addContact = EditContactController(loadPosition: options, delegate: self, contactDelegate: self, currentContact: cont, at: atIndexPath)
            self.removeObservers()
            blockSecondaryKeyboardCall = true
            addContact?.backColor = 0.8
            present(addContact!, animated: true, completion: {
            })
        }
    }

    func action(button: ActionButton, wasPressed: IndexPath) {
        
    }
    
    func contact(cell: ContactCell, indexPath: IndexPath, contact: Contact) {
        openActionViewFor(contact, at: indexPath)
    }
    
    func openActionViewFor(_ contact: Contact, at: IndexPath) {
        let size = CGSize(width: screen.width * 0.9, height: screen.width * 1.2)
        opaqueView = UIView(frame: CGRect(x: 0, y: 0, width: screen.width, height: screen.height))
        opaqueView?.backgroundColor = UIColor.clear
        view.addSubview(opaqueView!)
        profileAction = ActionProfile(contact: contact, delegate: self, intendedSize: size, index: at)
        profileAction?.evaluateSize()
        if let t = profileAction {
            profileAction?.frame.size = t.toSize
            profileAction?.to = CGPoint(x: view.frame.width / 2, y: self.view.frame.height - (t.toSize.height / 2) + t.layer.cornerRadius)
        }
        profileAction?.center.x = self.view.frame.width * 0.5
        profileAction?.center.y = self.view.frame.height * 1.5
        profileAction?.index = at
        profileAction?.set()
        opaqueView?.addSubview(profileAction!)
        profileAction?.present(opaqueView!)
    }
    
    func action(profile: ActionProfile, didClose: Bool) {
        if profile == profileAction, didClose {
            UIView.animate(withDuration: 0.3, animations: {
                profileAction?.center.y = self.view.frame.height * 1.5
                self.opaqueView?.backgroundColor = UIColor.clear
            }, completion: { (v) in
                profileAction?.removeFromSuperview()
                self.opaqueView?.removeFromSuperview()
                self.opaqueView?.gestureRecognizers?.removeAll()
                profileAction = nil
                self.opaqueView = nil
            })
        }
    }
    
    
    func header(button: ActionButton, wasPressed info: Any?) {
        if button == add {
            let corn = ModalCornerLayout.topBoth(10)
            let layouts = LayoutDiferences(top: 0, bottom: nil, corners: corn)
            let options = ModalViewControllerLayoutOptions(at: .visible, appear: .animation, relativeTo: .bottom, layed: layouts)
            let addContact = AddContactController(loadPosition: options, delegate: self, contactDelegate: self)
            self.removeObservers()
            blockSecondaryKeyboardCall = true
            addContact.backColor = 0.8
            present(addContact, animated: true, completion: {
            })
        }
    }
    
}




