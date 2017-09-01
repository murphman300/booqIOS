//
//  ProfilePic+CoreDataProperties.swift
//  
//
//  Created by Jean-Louis Murphy on 2017-08-16.
//
//

import Foundation
import CoreData


extension ProfilePic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfilePic> {
        return NSFetchRequest<ProfilePic>(entityName: "ProfilePic")
    }

    @NSManaged public var id: String?
    @NSManaged public var picture: NSObject?
    @NSManaged public var url: String?

}
