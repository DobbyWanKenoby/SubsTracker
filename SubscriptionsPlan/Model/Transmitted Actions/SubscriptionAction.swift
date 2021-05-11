//
// Данные о действиях над сущностью "Подписка"
//

enum SubscriptionAction: ActionData {    
    case new(subscription: SubscriptionProtocol)
    case loadAll
}
