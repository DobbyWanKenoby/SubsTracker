class CoordinatorFactory {
   
    static func getApplicationCoordinator() -> ApplicationCoordinatorProtocol {
        let controller = ControllerFactory.getDefaultController(byType: .tabBar)
        return ApplicationCoordinator(presenter: controller)
    }
    
    static func getAddSubscriptionCoordinator(rootCoordinator: Coordinator?) -> AddSubscriptionCoordinatorProtocol {
        let controller = ControllerFactory.getAddSubscriptionBaseController()
        return AddSubscriptionCoordinator(presenter: controller, rootCoordinator: rootCoordinator)
    }
    
    static func getSubscriptionsCoordinator(rootCoordinator: Coordinator?) -> SubscriptionsCoordinatorProtocol {
        let сontroller = ControllerFactory.getSubscriptionsBaseController()
        return SubscriptionsCoordinator(presenter: сontroller, rootCoordinator: rootCoordinator)
    }
    
    static func getCurrencyStorageActionService(rootCoordinator: Coordinator?) -> CurrencyStorageCoordinatorProtocol {
        return CurrencyStorageCoordinator(rootCoordinator: rootCoordinator)
    }
    
    static func getServiceStorageActionService(rootCoordinator: Coordinator?) -> ServiceStorageCoordinatorProtocol {
        return ServiceStorageCoordinator(rootCoordinator: rootCoordinator)
    }
    
    static func getSubscriptionStorageActionService(rootCoordinator: Coordinator?) -> SubscriptionStorageCoordinatorProtocol {
        return SubscriptionStorageCoordinator(rootCoordinator: rootCoordinator)
    }

}
