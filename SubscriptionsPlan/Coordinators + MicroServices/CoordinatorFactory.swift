class CoordinatorFactory {
    
    // MARK: - Main App Coordinator
    
    @discardableResult
    static func getApplicationCoordinator() -> ApplicationCoordinatorProtocol {
        let controller = ControllerFactory.getDefaultController(byType: .tabBar)
        return ApplicationCoordinator(presenter: controller)
    }
    
    // MARK: - Presenters
    
    @discardableResult
    static func getInitializatorCoordinator(rootCoordinator: Coordinator?) -> InitializatorCoordinatorProtocol {
        let controller = ControllerFactory.getInitializatorController()
        return InitializatorCoordinator(presenter: controller, rootCoordinator: rootCoordinator)
    }
    
    @discardableResult
    static func getAddSubscriptionCoordinator(rootCoordinator: Coordinator?) -> AddSubscriptionCoordinatorProtocol {
        let controller = ControllerFactory.getAddSubscriptionBaseController()
        return AddSubscriptionCoordinator(presenter: controller, rootCoordinator: rootCoordinator)
    }
//    
//    @discardableResult
//    static func getSubscriptionsCoordinator(rootCoordinator: Coordinator?) -> SubscriptionsCoordinatorProtocol {
//        let сontroller = ControllerFactory.getSubscriptionsBaseController()
//        return SubscriptionsCoordinator(presenter: сontroller, rootCoordinator: rootCoordinator)
//    }
//
    
    // MARK: - MicroServices Coordinators
    
    @discardableResult
    static func getCurrencyStorageMicroService(rootCoordinator: Coordinator?) -> CurrencyStorageCoordinatorProtocol {
        return CurrencyStorageCoordinator(rootCoordinator: rootCoordinator)
    }
    
    @discardableResult
    static func getServiceStorageMicroService(rootCoordinator: Coordinator?) -> ServiceStorageCoordinatorProtocol {
        return ServiceStorageCoordinator(rootCoordinator: rootCoordinator)
    }
    
    @discardableResult
    static func getCoreDataMicroService(rootCoordinator: Coordinator?) -> CoreDataCoordinatorProtocol {
        return CoreDataCoordinator(rootCoordinator: rootCoordinator)
    }
    
//    @discardableResult
//    static func getSubscriptionStorageActionService(rootCoordinator: Coordinator?) -> SubscriptionStorageCoordinatorProtocol {
//        return SubscriptionStorageCoordinator(rootCoordinator: rootCoordinator)
//    }

}
