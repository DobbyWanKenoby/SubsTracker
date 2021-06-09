//
//  CoreDataSignals.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 26.05.2021.
//

import Foundation
import CoreData

enum CoreDataSignal: Signal {
    case getDefaultContext
    case context (NSManagedObjectContext)
}



