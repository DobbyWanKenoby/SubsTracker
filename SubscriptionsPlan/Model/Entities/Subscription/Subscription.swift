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
    var identifier: UUID { get set }
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
    var nextPayment: (date: Date, daysRemain: Int) { get }
    /// Как часто платить по подписке
    var paymentPeriod: (Int, PeriodType) { get set }
    /// Используется ли нотификация
    var isNotificationable: Bool { get set }
    /// За сколько дней до оплаты уведомлять
    var notificationDaysPeriod: Int { get set }
}

struct Subscription: SubscriptionProtocol {
    
    var identifier: UUID
    var service: ServiceProtocol
    var amount: Float
    var currency: CurrencyProtocol
    var description: String
    var nextPaymentDate: Date
    var paymentPeriod: (Int, PeriodType)
    var isNotificationable: Bool
    var notificationDaysPeriod: Int
    
    var nextPayment: (date: Date, daysRemain: Int) {
        let todayDateComponents = Calendar.current.dateComponents([.day,.month,.year], from: Date())
        var nextDateComponents = Calendar.current.dateComponents([.day,.month,.year], from: nextPaymentDate)
        
        var daysRemain = Calendar.current.dateComponents([.day], from: todayDateComponents, to: nextDateComponents).day!
        
        if daysRemain >= 0 {
            return (Calendar.current.date(from: nextDateComponents)!, daysRemain)
        }
        
        // после изменения поля firstPaymentDate на nextPayment код далее выполняться не будет
        // так как PaymentCoordinator контролирует значение этого свойства
        // но на всякий случай оставлю
        
        repeat {
            var dateComponents = DateComponents()
            switch paymentPeriod.1 {
            case .day:
                dateComponents.day = paymentPeriod.0
            case .month:
                dateComponents.month = paymentPeriod.0
            case .week:
                dateComponents.day = paymentPeriod.0 * 7
            case .year:
                dateComponents.year = paymentPeriod.0
            }
            
            let date = Calendar.current.date(from: nextDateComponents)!
            let dateWithAdd = Calendar.current.date(byAdding: dateComponents, to: date)!
            nextDateComponents = Calendar.current.dateComponents([.day,.month,.year], from: dateWithAdd)
            
            daysRemain = Calendar.current.dateComponents([.day], from: todayDateComponents, to: nextDateComponents).day!
            
        } while daysRemain < 0
        
        return (Calendar.current.date(from: nextDateComponents)!, daysRemain)
    }
}
