//
//  ServiceAppData.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 01.01.2021.
//

import UIKit

// MARK: - Service Storage Data Layer

/// Протокол, описывающий реализацию хранилища сущностей "Сервис", работающую с конкретным типом хранилища
protocol ServiceStorageDataLayerProtocol {
    func getAll(withCustoms: Bool) -> [ServiceProtocol]
}

/// Локальное хранилище сущностей "Сервис"
class ServiceLocalStorage: ServiceStorageDataLayerProtocol {
    private lazy  var defaultServices: [ServiceProtocol] = getDefaultServices()
    
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
    
    func getAll(withCustoms: Bool = false) -> [ServiceProtocol] {
        return defaultServices
    }
}

// MARK: - Service Storage Front Layer

class ServiceStorage {
    static var `default`: ServiceStorageDataLayerProtocol {
        self.local
    }
    static var local: ServiceStorageDataLayerProtocol  = ServiceLocalStorage()
}
