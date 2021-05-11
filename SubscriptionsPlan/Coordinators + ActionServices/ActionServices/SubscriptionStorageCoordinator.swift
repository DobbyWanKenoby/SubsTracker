// Сервис, обеспечивающий работу с сущностью "Сервис"

import Foundation

protocol SubscriptionStorageCoordinatorProtocol: BaseCoordinator, ActionService {
    var subscriptions: [SubscriptionProtocol] { get set }
}

class SubscriptionStorageCoordinator: BaseCoordinator, SubscriptionStorageCoordinatorProtocol {
    
    var subscriptions: [SubscriptionProtocol] = []
    
    func handle(data: Any) -> Any? {
        guard let subscriptionAction = data as? SubscriptionAction else {
            return nil
        }
        
        // сохранение подпсики
        if case SubscriptionAction.new(let newSubscription) = data {
            subscriptions.append(newSubscription)
            return nil
        }
        
        switch (subscriptionAction, SubscriptionAction.loadAll) {
        case (SubscriptionAction.loadAll, SubscriptionAction.loadAll):
            return subscriptions
        default:
            return nil
        }
    }
}
