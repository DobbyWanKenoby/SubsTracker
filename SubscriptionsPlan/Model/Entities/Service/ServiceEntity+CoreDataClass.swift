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
public class ServiceEntity: NSManagedObject {
    
    static func createInstance(from service: ServiceProtocol, context: NSManagedObjectContext) -> ServiceEntity {
        let serviceEntity = ServiceEntity(context: context)
        serviceEntity.identifier = service.identifier
        serviceEntity.colorHEX = service.colorHEX
        serviceEntity.title = service.title
        serviceEntity.logoFileName = service.logoFileName
        serviceEntity.isCustom = service.isCustom
        return serviceEntity
    }
    
    func updateProperties(withService service: ServiceProtocol) {
        self.identifier = service.identifier
        self.title = service.title
        self.isCustom = service.isCustom
        self.logoFileName = service.logoFileName
        self.colorHEX = service.colorHEX
    }
    
    func convertToServiceInstance() -> ServiceProtocol {
        var service = Service(identifier: self.identifier!,
                              title: self.title!,
                              colorHEX: self.colorHEX!,
                              customLogoImage: self.logoFileName)
        service.isCustom = self.isCustom
        return service
    }
}
