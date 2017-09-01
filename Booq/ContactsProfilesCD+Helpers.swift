//
//  ContactsProfilesCD+Helpers.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-14.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit


extension ContactProfile {
    
    var object : [String:Any] {
        var ob : [String:Any] = [:]
        if let n = self.id {
            ob["id"] = n
        }
        if let n = self.name {
            ob["name"] = n
        }
        if let n = self.lastname {
            ob["lastname"] = n
        }
        if let n = self.imageURL {
            ob["picurl"] = n
        }
        if let n = self.email {
            ob["email"] = n
        }
        if let n = self.number {
            ob["phone"] = n
        }
        if let n = self.company {
            ob["company"] = n
        }
        if let n = self.job {
            ob["jobtitle"] = n
        }
        if let n = self.added {
            ob["added"] = n
        }
        if let n = self.picID {
            ob["picID"] = n
        }
        if let n = self.zip {
            ob["postalcode"] = n
        }
        return ob
    }
    
    func toContact() -> Contact? {
        do {
            let t = try Contact(from: self.object)
            return t
        } catch {
            return nil
        }
    }
    
    func updateFrom(_ contact : Contact) {
        guard self.id == contact.id else {
            return
        }
        self.id = contact.id
        self.name = contact.name
        if let n = contact.lastName {
            self.lastname = n
        }
        if let n = contact.picUrl {
            self.imageURL = n
        }
        if let n = contact.email {
            self.email = n
        }
        if let n = contact.phone {
            self.number = n.compact
        }
        if let n = contact.picID {
            self.picID = n
        }
        if let n = contact.postalCode {
            self.zip = n
        }
        self.company = contact.company
        self.job = contact.jobTitle
    }
    
    func checkUpdateFrom(_ contact : Contact) -> Bool {
        guard self.id == contact.id else { return false }
        guard !contact.id.isEmpty && !contact.name.isEmpty else { return false }
        self.id = contact.id
        self.name = contact.name
        if let n = contact.lastName {
            self.lastname = n
        }
        if let n = contact.picUrl {
            self.imageURL = n
        }
        if let n = contact.email {
            self.email = n
        }
        if let n = contact.phone {
            self.number = n.compact
        }
        if let n = contact.picID {
            self.picID = n
        }
        if let n = contact.postalCode {
            self.zip = n
        }
        self.added = contact.added as NSDate
        self.company = contact.company
        self.job = contact.jobTitle
        return true
    }
    
    func upDateFromNew(_ contact : Contact) -> Bool {
        self.id = contact.id
        self.name = contact.name
        if let n = contact.lastName {
        self.lastname = n
        }
        if let n = contact.picUrl {
        self.imageURL = n
        }
        if let n = contact.email {
        self.email = n
        }
        if let n = contact.phone {
        self.number = n.compact
        }
        if let n = contact.picID {
            self.picID = n
        }
        if let n = contact.postalCode {
            self.zip = n
        }
        self.added = contact.added as NSDate
        self.company = contact.company
        self.job = contact.jobTitle
        return true
    }
    
}
