// Сервис, обеспечивающий работу с сущностью "Сервис/Service"

import UIKit
import CoreData

protocol ServiceStorageCoordinatorProtocol: BaseCoordinator, Transmitter, Receiver {}

class ServiceStorageCoordinator: BaseCoordinator, ServiceStorageCoordinatorProtocol {
    
    // MARK: - CoreData
    
    lazy var context: NSManagedObjectContext = {
        let signalAnswer = broadcast(signalWithReturnAnswer: CoreDataSignal.getDefaultContext).first as! CoreDataSignal
        if case CoreDataSignal.context(let context) = signalAnswer {
            return context
        } else {
            fatalError("Can't get a Core Data context during app initialization process")
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
                if getServiceBy(identifier: service.identifier) == nil {
                    self.create(service: service)
                } else {
                    self.update(service: service)
                }
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
                guard let newService = (service as? ServiceEntity)?.convertToServiceInstance() as? Service else {
                    continue
                }
                resultServicesArray.append(newService)
            }
            return resultServicesArray
        } catch {
            fatalError("Error during load Service by identifier. Error message: \(error)")
        }
    }
    
    // создание сервиса
    private func create(service: ServiceProtocol) {
        let _ = ServiceEntity.createInstance(from: service, context: context)
        savePersistance()
    }
    
    // обновление сервиса
    // поиск происходит по идентификатору (identifier)
    private func update(service: ServiceProtocol) {
        let serviceEntity = getServiceEntityBy(identifier: service.identifier)
        serviceEntity?.updateProperties(withService: service)
        savePersistance()
    }
    
    // поиск сервиса
    private func getServiceBy(identifier: String) -> ServiceProtocol? {
        return getServiceEntityBy(identifier: identifier)?.convertToServiceInstance()
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
