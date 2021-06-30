//
// Данные о действиях над сущностью "Подписка"
//

enum SubscriptionSignal: Signal {
    // создание/обновление подписок
    // broadcastActualSubscriptionsList - необходимость рассылки списка актуальных подписок после создания/обновления
    //  рассылка происходит с помощью сигнала actualSubscriptions
    case createUpdate(subscriptions: [SubscriptionProtocol], broadcastActualSubscriptionsList: Bool = false)
    
    // получение всех подписок
    // ответ - сигнал subscriptions
    case getAll
    // передача подписок
    // может содержать не все подписки, а только запрошенные
    case subscriptions([SubscriptionProtocol])
    
    // список актуальных подписок
    // всегда содержит все действующие подписки
    case actualSubscriptions([SubscriptionProtocol])
}
