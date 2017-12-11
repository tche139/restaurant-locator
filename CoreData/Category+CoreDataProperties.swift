//
//  Category+CoreDataProperties.swift
//  Restaurant Locator
//
//  Created by Qingyun He on 08/09/2017.
//  Copyright © 2017 max. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var colorAsHex: String?
    @NSManaged public var icon: NSData?
    @NSManaged public var orderPosition: Int16
    @NSManaged public var title: String?
    @NSManaged public var restaurants: NSSet?

}

// MARK: Generated accessors for restaurants
extension Category {

    @objc(addRestaurantsObject:)
    @NSManaged public func addToRestaurants(_ value: Restaurnt)

    @objc(removeRestaurantsObject:)
    @NSManaged public func removeFromRestaurants(_ value: Restaurnt)

    @objc(addRestaurants:)
    @NSManaged public func addToRestaurants(_ values: NSSet)

    @objc(removeRestaurants:)
    @NSManaged public func removeFromRestaurants(_ values: NSSet)

}
