//
//  Restaurnt+CoreDataProperties.swift
//  Restaurant Locator
//
//  Created by Qingyun He on 08/09/2017.
//  Copyright © 2017 max. All rights reserved.
//

import Foundation
import CoreData


extension Restaurnt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurnt> {
        return NSFetchRequest<Restaurnt>(entityName: "Restaurant")
    }

    @NSManaged public var dateAdded: NSDate?
    @NSManaged public var latitude: Double
    @NSManaged public var logo: NSData?
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var notification: Bool
    @NSManaged public var orderPosition: Int16
    @NSManaged public var radius: Int32
    @NSManaged public var rating: Double
    @NSManaged public var address: String?
    @NSManaged public var category: Category?

}
