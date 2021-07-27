// Сервис, обеспечивающий работу с сущностью "Сервис/Service"

import UIKit
import CoreData
import SwiftCoordinatorsKit

protocol ServiceCoordinatorProtocol: BaseCoordinator, Transmitter, Receiver {}

class ServiceCoordinator: BaseCoordinator, ServiceCoordinatorProtocol {
    
    // MARK: - CoreData
    
    lazy var context: NSManagedObjectContext = {
        let signalAnswer = broadcast(signalWithReturnAnswer: CoreDataSignal.getDefaultContext).first as! CoreDataSignal
        if case CoreDataSignal.context(let context) = signalAnswer {
            return context
        } else {
            fatalError("Can't get a Core Data context in Service Coordinator")
        }
    }()
    
    func savePersistance() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error during saving Services to Storage. Error message: \(error)")
            }
        }
    }
    
    // MARK: - Receiver
    
    func receive(signal: Signal) -> Signal? {
        switch signal {
        
        // Запрос Сервиса по идентификатору
        case ServiceSignal.getServiceByIdentifier(let identifier):
            if let service = getServiceBy(identifier: identifier) {
                return ServiceSignal.service(service)
            }
        
        // создание/обновление Сервиса
        case ServiceSignal.createUpdateIfNeeded(let services):
            services.forEach{ service in
                createUpdateIfNeeded(from: service)
            }
            
        // загрузка Сервисов
        case ServiceSignal.load(let loadType):
            let services = loadServices(withType: loadType)
            let signalLoadedServices = ServiceSignal.services(services)
            return signalLoadedServices
            
        default:
            break
        }
        
        return nil
    }
    
    private func createUpdateIfNeeded(from service: ServiceProtocol) {
        ServiceEntity.getEntity(from: service, context: context, updateEntityPropertiesIfNeeded: true)
        savePersistance()
    }
    
    // получение списка сервисов
    private func loadServices(withType servicesType: ServicesLoadingType) -> [ServiceProtocol] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ServiceEntity")
        if servicesType == .default {
            fetchRequest.predicate = NSPredicate(format: "isCustom = NO")
        } else if servicesType == .custom {
            fetchRequest.predicate = NSPredicate(format: "isCustom = YES")
        }
        do {
            let services = try context.fetch(fetchRequest)
            var resultServicesArray = [Service]()
            for service in services {
                guard let newService = (service as? ServiceEntity)?.convertEntityToInstance() as? Service else {
                    continue
                }
                resultServicesArray.append(newService)
            }
            return resultServicesArray
        } catch {
            fatalError("Error during load Service by identifier. Error message: \(error)")
        }
    }
    
    // поиск сервиса
    private func getServiceBy(identifier: String) -> ServiceProtocol? {
        return getServiceEntityBy(identifier: identifier)?.convertEntityToInstance()
    }
    
    // поиск сервиса
    private func getServiceEntityBy(identifier: String) -> ServiceEntity? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ServiceEntity")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", identifier)
        do {
            guard let service = try context.fetch(fetchRequest).first else {
                return nil
            }
            return service as? ServiceEntity
        } catch {
            fatalError("Error during load ServiceEntity with identifier \(identifier)")
        }
    }
    
}
