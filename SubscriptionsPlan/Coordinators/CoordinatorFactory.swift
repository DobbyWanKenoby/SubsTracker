class CoordinatorFactory {
   
    static func getApplicationCoordinator() -> ApplicationCoordinatorProtocol {
        let controller = ControllerFactory.getDefaultController(byType: .tabBar)
        return ApplicationCoordinator(presenter: controller)
    }
    
    static func getAddSubscriptionCoordinator(rootCoordinator: Coordinator?) -> AddSubscriptionCoordinatorProtocol {
        let controller = ControllerFactory.getAddSubscriptionNavigationController()
        return AddSubscriptionCoordinator(presenter: controller, rootCoordinator: rootCoordinator)
    }
    
    static func getServiceStorageCoordinator(rootCoordinator: Coordinator?) -> ServiceStorageCoordinatorProtocol {
        return ServiceStorageCoordinator(rootCoordinator: rootCoordinator)
    }
    
//    private func getNotificationAlertCoordinator() -> NotificationAlertCoordinator {
//        let controller = UIViewController()
//        return NotificationAlertCoordinator(presenter: controller)
//    }
//
//    private func getUpcomingCoordinator() -> UpcomingCoordinator {
//        let rootController = ControllerFactory.getUpcomingNavigationController()
//        return UpcomingCoordinator(presenter: rootController)
//    }
//

    
}
