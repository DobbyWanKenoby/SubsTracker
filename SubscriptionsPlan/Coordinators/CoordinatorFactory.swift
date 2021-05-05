class CoordinatorFactory {
   
    static func getApplicationCoordinator() -> ApplicationCoordinator {
        let controller = ControllerFactory.getDefaultController(byType: .tabBar)
        return ApplicationCoordinator(presenter: controller)
    }
    
    static func getAddSubscriptionCoordinator(rootCoordinator: Coordinator?) -> AddSubscriptionCoordinator {
        let controller = ControllerFactory.getAddSubscriptionNavigationController()
        return AddSubscriptionCoordinator(presenter: controller, rootCoordinator: rootCoordinator)
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
