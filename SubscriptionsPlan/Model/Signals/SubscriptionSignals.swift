//
// Данные о действиях над сущностью "Подписка"
//

import SwiftCoordinatorsKit

enum SubscriptionSignal: Signal {
    // создание/обновление подписок
    // broadcastActualSubscriptionsList - необходимость рассылки списка актуальных подписок после создания/обновления
    // -> actualSubscriptions
    case createUpdate(subscriptions: [SubscriptionProtocol], broadcastActualSubscriptionsList: Bool = false)
    
    // получение всех подписок
    // -> subscriptions
    case getAll
    
    // передача подписок
    // может содержать не все подписки, а только запрошенные
    case subscriptions([SubscriptionProtocol])
    
    // запрашивает запрос актуальных подписок
    // broadcastActualSubscriptionsList - необходимость рассылки списка актуальных подписок
    // -> actualSubscriptions
    case getActualSubscriptions(broadcastActualSubscriptionsList: Bool)
    
    // список актуальных подписок
    // всегда содержит все действующие подписки
    case actualSubscriptions([SubscriptionProtocol])
    
    // проверяет подписку на уже совершенные платежи
    // они появляются, когда дата следующего платежа
    // раньше текущей даты
    // -> createUpdate
    case checkSubscriptionOnPayments(SubscriptionProtocol)
}
