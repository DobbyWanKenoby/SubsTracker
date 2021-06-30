//
//  ServiceEntity+CoreDataClass.swift
//  SubscriptionsPlan
//
//  Created by Admin on 02.06.2021.
//
//

import Foundation
import CoreData

@objc(ServiceEntity)
public class ServiceEntity: NSManagedObject, EntityInstanceProvider {
    
    typealias AssociatedInstanceType = ServiceProtocol
    
    @discardableResult
    static func getEntity(from service: ServiceProtocol, context: NSManagedObjectContext, updateEntityPropertiesIfNeeded: Bool = false) -> Self {
        let fetch = NSFetchRequest<ServiceEntity>(entityName: "ServiceEntity")
        fetch.predicate = NSPredicate(format: "identifier = %@", service.identifier)
        fetch.fetchBatchSize = 1
        guard let servicesFromStorage = try? context.fetch(fetch),
              let serviceFromStorage = servicesFromStorage.first else {
            let serviceEntity = ServiceEntity(context: context)
            serviceEntity.updateEntity(from: service, context: context)
            return serviceEntity as! Self
        }
        if updateEntityPropertiesIfNeeded {
            serviceFromStorage.updateEntity(from: service, context: context)
        }
        return serviceFromStorage as! Self
    }
    
    func updateEntity(from service: ServiceProtocol, context: NSManagedObjectContext) {
        self.identifier = service.identifier
        self.colorHEX = service.colorHEX
        self.title = service.title
        self.logoFileName = service.logoFileName
        self.isCustom = service.isCustom
    }
    
    func convertEntityToInstance() -> ServiceProtocol {
        var service = Service(identifier: self.identifier!,
                                      title: self.title!,
                                      colorHEX: self.colorHEX!,
                                      customLogoImage: self.logoFileName)
        service.isCustom = self.isCustom
        return service
    }
}
