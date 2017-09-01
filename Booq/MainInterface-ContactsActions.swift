//
//  MainInterface-ContactsActions.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-05.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

enum Update: Any {
    case Add
    case Delete
    case Change
}

import SCKBase

extension UIViewController {
    
    func canOpen(_ url : String) -> URL? {
        guard let number = NSURL(string: url) else { return nil }
        guard UIApplication.shared.canOpenURL(number as URL) else { return nil }
        return number as URL
    }
    
    func predicateAppURL(_ url: String) {
        guard let path = canOpen(url) else { return }
        App.defaults.leftApp = true
        UIApplication.shared.open(path, options: [:]) { (v) in
            print("Opened url: url")
        }
    }
    
    func predicateURL(_ url: String) -> Bool {
        guard let path = canOpen(url) else { return false }
        App.defaults.leftApp = true
        UIApplication.shared.open(path, options: [:]) { (v) in
            print("Opened url: url")
        }
        return true
    }
    
}

extension MainController: AddContactUserResponseDelegate, ModalViewControllerPanningDelegate, EditContactUserResponseDelegate {
    
    func add(user: AddContactController, didAdd: Contact) {
        ContactsCache.pipe.contacts.append(didAdd)
        self.main.reloadData()
    }
    
    func edit(user: EditContactController, didEdit: Contact, at: IndexPath) {
        ContactsCache.pipe.update(didEdit, {
            DispatchQueue.main.async {
                if let it = profileAction {
                    it.applyContactFromEdit(didEdit)
                }
                if let item = ContactsCache.pipe.indexPathToContacts[didEdit.id] {
                    self.main.performBatchUpdates({
                        self.main.reloadItems(at: [item])
                    }, completion: { (v) in
                        
                    })
                } else {
                    self.main.reloadData()
                }
            }
        })
    }
    
    func edit(user: EditContactController, didDelete: Contact, at: IndexPath) {
        if let t = ContactsCache.pipe.contacts.index(where: {return $0 == didDelete}) {
            self.main.performBatchUpdates({
                ContactsCache.pipe.contacts.remove(at: t)
                self.main.deleteItems(at: [at])
            }, completion: { (v) in
                print("Deleted From Collection")
            })
            if let p = profileAction, p.currentContact == didDelete {
                p.applyContactFromEdit(nil)
            }
        }
    }
    
    func modal(viewController: ModalViewController, did pan: CGFloat) {
        
    }
    
    func modal(viewController: ModalViewController, dismissed: Bool, with remaining: CGFloat) {
        self.reApplyRemovedObservers()
        blockSecondaryKeyboardCall = false
    }
    
}
