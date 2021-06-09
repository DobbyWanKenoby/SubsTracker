//
//  Service+CoreDataClass.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 26.05.2021.
//
//

import UIKit
import CoreData

@objc(Service)
public class Service: NSManagedObject, ServiceProtocol {
    var logo: UIImage {
        return UIImage(named: identifier)!
    }
    
    var color: UIColor {
        return UIColor(hex: colorHEX)!
    }
}
