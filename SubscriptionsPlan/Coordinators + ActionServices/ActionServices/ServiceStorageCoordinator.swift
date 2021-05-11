// Сервис, обеспечивающий работу с сущностью "Сервис/Service"

import UIKit

protocol ServiceStorageCoordinatorProtocol: BaseCoordinator, ActionService {}

class ServiceStorageCoordinator: BaseCoordinator, ServiceStorageCoordinatorProtocol {
    func handle(data: Any) -> Any? {
        if case ServiceAction.load(let type) = data {
            //let loadCustomsServices: Bool = (type == .all) ? true : false
            return self.getDefaultServices()
        }
        return nil
    }
}

// MARK: Работа с хранилищем Сервисов

extension ServiceStorageCoordinator {
    private func getDefaultServices() -> [ServiceProtocol] {
        // загрузка стандартных сервисов из Plist-файла
        let servicesDictionary: [[String:String]]
        guard let path = Bundle.main.path(forResource: "Services", ofType: "plist") else {
            return []
        }
        servicesDictionary = NSArray(contentsOfFile: path) as! [[String : String]]
        
        var services: [ServiceProtocol] = []
        // разбор загруженных сервисов
        servicesDictionary.forEach { serviceItemFromPlistFile in
            let identifier = (serviceItemFromPlistFile["identifier"]!).lowercased()
            let title: String
            if serviceItemFromPlistFile["isLocalizable"]! == "1" {
                title = NSLocalizedString("service_\(identifier)", comment: "")
            } else {
                title = (serviceItemFromPlistFile["identifier"]!)
            }
            
            let logo = UIImage(named: serviceItemFromPlistFile["identifier"]!)
            let color = UIColor(hex: serviceItemFromPlistFile["color"]!) ?? UIColor.black
            services.append(Service(identifier: identifier, title: title, logo: logo, color: color))
        }
        return services
    }
}
