import UIKit

// MARK: - Фабрика контроллеров

class ControllerFactory {
    
    static func getDefaultController(byType type: ControllerType) -> UIViewController {
        switch type {
        case .tabBar:
            return UITabBarController()
        case .navigation:
            return UINavigationController()
        }
    }
    
    static func getAddSubscriptionNavigationController() -> AddSubscriptionControllerProtocol {
        return AddSubscriptionNavigationController.getInstance()
    }
    
    static func getServiceListController() -> ServicesListControllerProtocol {
        return ServicesListController.getInstance()
    }
    
    static func getAddSubscriptionController() -> AddSubscriptionProtocol {
        return AddSubscriptionController.getInstance()
    }
    
    static func getNotificationAlertController() -> NotificationAlertController {
        return NotificationAlertController.getInstance()
    }
    
//    static func getUpcomingNavigationController() -> UpcomingNavigationController {
//        return UpcomingNavigationController.getInstance()
//    }
//    
//    static func getUpcomingController() -> UpcomingTransferInterface {
//        return UpcomingViewController.getInstance()
//    }
//    

//    

//    

//    

}
