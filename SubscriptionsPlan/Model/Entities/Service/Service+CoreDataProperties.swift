//
//  Service+CoreDataProperties.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 26.05.2021.
//
//

import Foundation
import CoreData


extension Service {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Service> {
        return NSFetchRequest<Service>(entityName: "Service")
    }

    @NSManaged public var colorHEX: String
    @NSManaged public var title: String
    @NSManaged public var identifier: String
    @NSManaged public var logoURI: URL

}
