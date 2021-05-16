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
    
    // Экземпляр AddSubscriptionController
    // В связи с неисправленным retain cycle используется данное свойство
    private static var addSubscriptionController: AddSubscriptionControllerProtocol!
    // Контроллер для создания подписки
    static func getAddSubscriptionController() -> AddSubscriptionControllerProtocol {
        if addSubscriptionController == nil {
            addSubscriptionController = AddSubscriptionController.getInstance()
        }
        return addSubscriptionController
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
