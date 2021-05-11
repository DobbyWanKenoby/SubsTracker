import UIKit

// MARK: - Фабрика контроллеров

class ControllerFactory {
    
    // Дефолтные контроллеры без особых настроек
    static func getDefaultController(byType type: ControllerType) -> UIViewController {
        switch type {
        case .tabBar:
            return UITabBarController()
        case .navigation:
            return UINavigationController()
        }
    }
    
    // Базовый контроллер для созданяи подписки
    static func getAddSubscriptionBaseController() -> AddSubscriptionBaseControllerProtocol {
        return AddSubscriptionNavigationController.getInstance()
    }
    
    // Контроллер для отображения предустановленных сервисов
    static func getServiceListController() -> ServicesListControllerProtocol {
        return ServicesListController.getInstance()
    }
    
    // Контроллер для создания подписки
    static func getAddSubscriptionController() -> AddSubscriptionControllerProtocol {
        return AddSubscriptionController.getInstance()
    }
    
    // Контроллер нотификаций
    static func getNotificationAlertController() -> NotificationAlertController {
        return NotificationAlertController.getInstance()
    }
    
    // Базовый контроллер для отображения списка подписок
    static func getSubscriptionsBaseController() -> SubscriptionsBaseControllerProtocol {
        return SubscriptionsNavigationController.getInstance()
    }
    
    // Контроллер для отображенния списка созданных подписок
    static func getSubscriptionsListController() -> SubscriptionsListControllerProtocol {
        return SubscriptionsListController.getInstance()
    }

}
