//
//  Contact.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-07.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

enum ContactInitError : Error {
    case missing(String)
}

class Contact: Equatable {
    
    var id = String()
    var name = String()
    var lastName : String?
    var postalCode : String?
    var email : String?
    var phone : PhoneNumber?
    var dob : DOB?
    var picUrl : String?
    var company = String()
    var jobTitle = String()
    var added = Date()
    var picID : String?
    
    init() {
        id = UUID.init().uuidString
    }
    
    init(data: Data) {
        
    }
    
    init(contact: Contact) {
        id = contact.id
        name = contact.name
        lastName = contact.lastName
        picUrl = contact.picUrl
        email = contact.email
        phone = contact.phone
        company = contact.company
        jobTitle = contact.jobTitle
        picID = contact.picID
        postalCode = contact.postalCode
    }
    
    init(info: [String:Any]) {
        if let n = info["id"] as? String {
            id = n
        }
        if let n = info["name"] as? String {
            name = n
        }
        if let n = info["lastname"] as? String {
            lastName = n
        }
        if let n = info["picurl"] as? String {
            picUrl = n
        }
        if let n = info["email"] as? String {
            email = n
        }
        if let n = info["phone"] as? String {
            do {
                phone = try PhoneNumber(number: n)
            } catch {
                print("Invalid Number")
            }
        }
        if let n = info["company"] as? String {
            company = n
        }
        if let n = info["jobtitle"] as? String {
            jobTitle = n
        }
        if let picid = info["picID"] as? String {
            picID = picid
        }
        if let pc = info["postalcode"] as? String {
            postalCode = pc
        }
    }
    
    convenience init(from: [String:Any]) throws {
        self.init()
        if let n = from["id"] as? String {
            id = n
        } else {
            throw ContactInitError.missing("id")
        }
        if let n = from["name"] as? String {
            name = n
        } else {
            throw ContactInitError.missing("name")
        }
        if let n = from["lastname"] as? String {
            lastName = n
        }
        if let n = from["picurl"] as? String {
            picUrl = n
        }
        if let n = from["email"] as? String {
            email = n
        }
        if let n = from["phone"] as? String {
            do {
                phone = try PhoneNumber(number: n)
            } catch {
                print("Invalid Number")
            }
        }
        if let n = from["company"] as? String {
            company = n
        }
        if let n = from["jobtitle"] as? String {
            jobTitle = n
        }
        if let ad = from["added"] as? Date {
            self.added = ad
        }
        if let picid = from["picID"] as? String {
            picID = picid
        }
        if let pc = from["postalcode"] as? String {
            postalCode = pc
        }
    }
    
    var jobDescriptionTwoLinesJob : String{
        return jobTitle + "\r" + company
    }
    
    static func !=(_ lhs: Contact,_ rhs: Contact) -> Bool {
        return  lhs.id != rhs.id
    }
    
    static func ==(_ lhs: Contact,_ rhs: Contact) -> Bool {
        return  lhs.id == rhs.id
    }
    
}
