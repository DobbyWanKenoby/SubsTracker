//
//  Sbscription.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 31.12.2020.
//

import UIKit

// MARK: - Подписка

enum PeriodType: String, CaseIterable {
    case day
    case week
    case month
    case year
    
    func getLocaleTitle() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

protocol SubscriptionProtocol {
    /// Уникальный числовой идентификатор подписки
    var identifier: Int? { get set }
    /// На какой сервис осуществляется подписка
    var service: ServiceProtocol { get set }
    /// Сумма подписки
    var amount: Float { get set }
    /// Валюта
    var currency: CurrencyProtocol { get set }
    /// Описание/примечание
    var description: String { get set }
    /// Дата первого платежа
    var nextPaymentDate: Date { get set }
    /// Как часто платить по подписке
    var paymentPeriod: (Int, PeriodType) { get set }
}

protocol SubscriptionStorageProtocol {
    static func save(_ subscription: SubscriptionProtocol)
    static func load() -> [SubscriptionProtocol]
}

struct Subscription: SubscriptionProtocol, SubscriptionStorageProtocol {
    var identifier: Int?
    var service: ServiceProtocol
    var amount: Float
    var currency: CurrencyProtocol
    var description: String
    var nextPaymentDate: Date
    var paymentPeriod: (Int, PeriodType)
    
    static func save(_ subscription: SubscriptionProtocol) {
        (UIApplication.shared.delegate as! AppDelegate).subscriptions.append(subscription)
    }
    
    static func load() -> [SubscriptionProtocol] {
        return (UIApplication.shared.delegate as! AppDelegate).subscriptions
    }
}
