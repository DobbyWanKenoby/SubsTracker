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
    
    // Контроллер инициализатора приложения
    // Запускается и отображается первым и производит различные первичные операции, вроде загрузки данных из сети, сохранения данных в базу и т.д.
    static func getInitializatorController() -> InitializatorControllerProtocol {
        return InitializatorController.getInstance()
    }
    
    // Базовый контроллер основных функций приложения
    // Отображается после инициализатора
    static func getFunctionalController() -> UITabBarController {
        return Self.getDefaultController(byType: .tabBar) as! UITabBarController
    }
    
    // Базовый контроллер для создания подписки
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
        // Вариант без перерасхода памяти
//        if addSubscriptionController == nil {
//            addSubscriptionController = AddSubscriptionController.getInstance()
//        }
//        return addSubscriptionController
        
        // Вариант с перерасходом памяти
        // и без сохранения значений на форме создания подписки
        // Логически более верный, но перерасход памяти
        return AddSubscriptionController.getInstance()
    }
    
    // Контроллер нотификаций
    static func getNotificationAlertController() -> NotificationAlertController {
        return NotificationAlertController.getInstance()
    }
    
    // Базовый контроллер для отображения списка подписок
    static func getSubscriptionListBaseController() -> SubscriptionsBaseControllerProtocol {
        return SubscriptionListBaseController.getInstance()
    }
    
    // Контроллер для отображенния списка созданных подписок
    static func getSubscriptionsListController() -> SubscriptionsListControllerProtocol {
        return SubscriptionsListController.getInstance()
    }

}
