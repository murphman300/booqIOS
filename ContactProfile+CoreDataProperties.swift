//
//  ContactProfile+CoreDataProperties.swift
//  
//
//  Created by Jean-Louis Murphy on 2017-08-16.
//
//

import Foundation
import CoreData


extension ContactProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactProfile> {
        return NSFetchRequest<ContactProfile>(entityName: "ContactProfile")
    }

    @NSManaged public var added: NSDate?
    @NSManaged public var age: Double
    @NSManaged public var company: String?
    @NSManaged public var dob: String?
    @NSManaged public var email: String?
    @NSManaged public var favourite: Bool
    @NSManaged public var id: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var job: String?
    @NSManaged public var lastname: String?
    @NSManaged public var name: String?
    @NSManaged public var number: String?
    @NSManaged public var zip: String?
    @NSManaged public var picID: String?

}
