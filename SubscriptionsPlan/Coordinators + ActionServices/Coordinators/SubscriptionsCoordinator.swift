import UIKit

protocol SubscriptionsCoordinatorProtocol: BasePresenter, Transmitter {}

class SubscriptionsCoordinator: BasePresenter, SubscriptionsCoordinatorProtocol, ActionService {
    func handle(data: Any) -> Any? {
        // при поступлении данных о создании новой подписки
        // нужно обновить список подписок на соответствующем экране
        if case SubscriptionAction.new = data {
            childControllers.forEach { controller in
                (controller as? SubscriptionsListController)?.subscriptions = getSubscriptions()
            }
        }
        return nil
    }
    
    private var navigationPresenter: UINavigationController? {
        return presenter as? UINavigationController
    }
    
    override func startFlow() {
        navigationPresenter?.navigationBar.prefersLargeTitles = true
        navigationPresenter?.pushViewController(getSubscriptionsListConfiguredController(), animated: false)
    }
    
    // Возвращает готовый контроллер со списком Сервисов
    private func getSubscriptionsListConfiguredController() -> UIViewController {
        let subsListController = ControllerFactory.getSubscriptionsListController()
        childControllers.append(subsListController)
        subsListController.subscriptions = getSubscriptions()
        return subsListController
    }
    
    // загрузка подписок
    private func getSubscriptions() -> [SubscriptionProtocol] {
        // Загрузка подписок и их передача в контроллер
        let serviceRequest = SubscriptionAction.loadAll
        let response = self.transmit(data: [serviceRequest], sourceCoordinator: self)
        if let subscriptions = response.first as? [SubscriptionProtocol] {
            return subscriptions
        }
        return []
    }
}
