//
//  Singer+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by BPS.Dev01 on 6/23/23.
//
//

import Foundation
import CoreData


extension Singer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Singer> {
        return NSFetchRequest<Singer>(entityName: "Singer")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    
    var wrappedFirstName: String {
        firstName ?? "Unknown Name"
    }
    
    var wrappedlastName: String {
        lastName ?? "Unknown Last Name"
    }

}

extension Singer : Identifiable {

}
