// Сервис, обеспечивающий работу с сущностью "Сервис/Service"

import UIKit
import CoreData

protocol ServiceStorageCoordinatorProtocol: BaseCoordinator, Transmitter, Receiver {}

class ServiceStorageCoordinator: BaseCoordinator, ServiceStorageCoordinatorProtocol {
    
    var context: NSManagedObjectContext!
    
    required init(rootCoordinator: Coordinator? = nil) {
        super.init(rootCoordinator: rootCoordinator)
        // Загрузка контекста CoreData
        let contextRequest = CoreDataSignal.getDefaultContext
        broadcast(signal: contextRequest, withAnswerToReceiver: self)
    }
    
    func receive(signal: Signal) -> Signal? {
        switch signal {
        case ServiceSignal.load(let type):
            break
        case CoreDataSignal.context(let contextFromAnswer):
            context = contextFromAnswer
        default:
            break
        }
//
//
//        if case ServiceSignal.load(let type) = signal {
//            //let loadCustomsServices: Bool = (type == .all) ? true : false
//            return ServiceSignal.actualServices(services: self.getDefaultServices())
//        }
        return nil
    }
}

// MARK: Работа с хранилищем Сервисов

extension ServiceStorageCoordinator {
    
    // MARK: Установка сервисов
    
//    // установка сервисов из plist в CoreData
//    func installServices() {
//        // загрузка стандартных сервисов из Plist-файла
//        let servicesDictionary: [[String:String]]
//        guard let path = Bundle.main.path(forResource: "Services", ofType: "plist") else {
//            return
//        }
//        servicesDictionary = NSArray(contentsOfFile: path) as! [[String : String]]
//
//        var services: [ServiceProtocol] = []
//        // разбор загруженных сервисов
//        servicesDictionary.forEach { serviceItemFromPlistFile in
//            let identifier = (serviceItemFromPlistFile["identifier"]!).lowercased()
//            let title: String
//            if serviceItemFromPlistFile["isLocalizable"]! == "1" {
//                title = NSLocalizedString("service_\(identifier)", comment: "")
//            } else {
//                title = (serviceItemFromPlistFile["identifier"]!)
//            }
//
//            let logo = UIImage(named: serviceItemFromPlistFile["identifier"]!)
//            let color = UIColor(hex: serviceItemFromPlistFile["color"]!) ?? UIColor.black
//            //services.append(Service(identifier: identifier, title: title, logo: logo, color: color))
//        }
//        return
//    }
//
//    private func getPreinstalledServices() -> [ServiceProtocol] {
//
//    }
}
