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
    /// Если nil, то создается новая подписка
    var identifier: UUID? { get set }
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
    /// Используется ли нотификация
    var isNotificationable: Bool { get set }
    /// За сколько дней до оплаты уведомлять
    var notificationDaysPeriod: Int { get set }
}

struct Subscription: SubscriptionProtocol {
    var identifier: UUID?
    var service: ServiceProtocol
    var amount: Float
    var currency: CurrencyProtocol
    var description: String
    var nextPaymentDate: Date
    var paymentPeriod: (Int, PeriodType)
    var isNotificationable: Bool
    var notificationDaysPeriod: Int
}
