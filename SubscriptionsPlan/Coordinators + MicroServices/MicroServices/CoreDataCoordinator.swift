/**
    Обеспечивает работу с Core Data
 */

import Foundation
import CoreData
import SwiftCoordinatorsKit

protocol CoreDataCoordinatorProtocol: BaseCoordinator, Receiver {}

// MARK: - Receiver

class CoreDataCoordinator: BaseCoordinator, CoreDataCoordinatorProtocol {
    lazy var persistanceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SubsTracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func receive(signal: Signal) -> Signal? {
        if case CoreDataSignal.getDefaultContext = signal {
            return CoreDataSignal.context(getMainContext())
        }
        return nil
    }
}

// MARK: - Receiver logic

extension CoreDataCoordinator {
    
    func getMainContext() -> NSManagedObjectContext {
        persistanceContainer.viewContext
    }
}
