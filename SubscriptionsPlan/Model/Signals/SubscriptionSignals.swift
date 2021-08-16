//
// Данные о действиях над сущностью "Подписка"
//

import Foundation
import SwiftCoordinatorsKit

enum SubscriptionSignal: Signal {
    // создание/обновление подписок
    // broadcastActualSubscriptionsList - необходимость рассылки списка актуальных подписок после создания/обновления
    //
    // Если broadcastActualSubscriptionsList == true
    // -> actualSubscriptions
    case createUpdate(subscriptions: [SubscriptionProtocol], broadcastActualSubscriptionsList: Bool = false)
    
    // получение всех подписок
    //
    // Всегда возвращает
    // -> subscriptions
    // case getAll
    
    // передача подписок
    // может содержать не все подписки, а только запрошенные
    // для передачи именно актуальных подписок используется сигнал actualSubscriptions
    case subscriptions([SubscriptionProtocol])
    
    // запрашивает список актуальных подписок
    // broadcastActualSubscriptionsList - необходимость рассылки списка актуальных подписок по иерархии
    //
    // Если broadcastActualSubscriptionsList == true
    // -> actualSubscriptions
    case getActualSubscriptions(broadcastActualSubscriptionsList: Bool)
    
    // список актуальных подписок
    // всегда содержит все действующие подписки
    case actualSubscriptions([SubscriptionProtocol])
    
    // проверяет подписку на уже совершенные платежи
    // они появляются, когда дата следующего платежа
    // раньше текущей даты
    //
    // Всегда отправляет 
    // -> PaymentSubscription.createUpdate
    // -> createUpdate
    case checkSubscriptionsOnPayments([SubscriptionProtocol])
    
    // удаляет указанную подписку
    //
    // Если removePayments == true
    // -> removePayments
    case removeSubscription(id: UUID, removePayments: Bool)
}
