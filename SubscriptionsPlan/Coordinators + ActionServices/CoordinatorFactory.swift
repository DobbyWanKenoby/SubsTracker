class CoordinatorFactory {
   
    static func getApplicationCoordinator() -> ApplicationCoordinatorProtocol {
        let controller = ControllerFactory.getDefaultController(byType: .tabBar)
        return ApplicationCoordinator(presenter: controller)
    }
    
    static func getAddSubscriptionCoordinator(rootCoordinator: Coordinator?) -> AddSubscriptionCoordinatorProtocol {
        let controller = ControllerFactory.getAddSubscriptionBaseController()
        return AddSubscriptionCoordinator(presenter: controller, rootCoordinator: rootCoordinator)
    }
    
    static func getServiceStorageCoordinator(rootCoordinator: Coordinator?) -> ServiceStorageCoordinatorProtocol {
        return ServiceStorageCoordinator(rootCoordinator: rootCoordinator)
    }
    
    static func getSubscriptionsCoordinator(rootCoordinator: Coordinator?) -> SubscriptionsCoordinatorProtocol {
        let сontroller = ControllerFactory.getSubscriptionsBaseController()
        return SubscriptionsCoordinator(presenter: сontroller, rootCoordinator: rootCoordinator)
    }

}
