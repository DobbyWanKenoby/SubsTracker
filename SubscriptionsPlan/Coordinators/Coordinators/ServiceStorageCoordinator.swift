//
//  ServiceStorageMicroService.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 05.05.2021.
//

import Foundation

protocol ServiceStorageCoordinatorProtocol: BaseCoordinator, DataService {}

class ServiceStorageCoordinator: BaseCoordinator, DataService, ServiceStorageCoordinatorProtocol {
    func handle(data: DataRequest) -> DataResponse? {
        return nil
    }
}

// MARK: - Request&Response Types

class LoadServicesRequest: DataRequest {
    var type: ServicesType
    init(type: ServicesType) {
        self.type = type
    }
    
    enum ServicesType {
        case all
        case system
        case user
    }
}

class ServicesResponse: DataResponse {
    var services: [ServiceProtocol] = []
}
