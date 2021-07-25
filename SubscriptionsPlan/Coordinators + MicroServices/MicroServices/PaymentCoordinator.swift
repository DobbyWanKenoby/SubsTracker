//
//  SubscriptionHandlerCoordinator.swift
//  SubscriptionsPlan
//
//  Created by Admin on 01.07.2021.
//

import Foundation

protocol PaymentsCoordinatorProtocol: BaseCoordinator, Transmitter {}

// MARK: - Receiver

class PaymentsCoordinator: BaseCoordinator, PaymentsCoordinatorProtocol {

    func receive(signal: Signal) -> Signal? {
        if case SubscriptionSignal.checkSubscriptionOnPayments(var subscription) = signal {
            if isNeedCreatePayments(for: subscription) {
                let payments = getNewPayments(for: &subscription)
            }
            return nil
        }
        return nil
    }
    
    func edit(signal: Signal) -> Signal {
        var updatedSignal = signal
        // Проверка подписки, не прошел ли срок следующего платежа
        // И при необходимости создается запись о платеже
        if case SubscriptionSignal.createUpdate(subscriptions: var subscriptions, broadcastActualSubscriptionsList: let broadcast) = signal {
            for var (subscriptionIndex, subscriptionItem) in subscriptions.enumerated() {
                print(222)
                while isNeedCreatePayments(for: subscriptionItem) {
                    let nextPayment = getNextPayment(for: &subscriptionItem, addPeriodToSubscriptionNextPaymentDate: true)
                    print(nextPayment)
                }
                print(111)
                subscriptions[subscriptionIndex] = subscriptionItem
            }
            updatedSignal = SubscriptionSignal.createUpdate(subscriptions: subscriptions, broadcastActualSubscriptionsList: broadcast)
        }
        
        return updatedSignal
    }
}

// MARK: - Payments Stroage Logic

extension PaymentsCoordinator {
    
}

// MARK: - Payments Logic

extension PaymentsCoordinator {
    
    fileprivate func isNeedCreatePayments(for subscription: SubscriptionProtocol) -> Bool {
        if Date() > subscription.nextPaymentDate {
            return true
        }
        return false
    }
    
    // Возвращает ОДИН новый платеж для подписки
    // Его дата соответствует дате следующего платежа
    fileprivate func getNextPayment(for subscription: inout SubscriptionProtocol, addPeriodToSubscriptionNextPaymentDate isEdit: Bool = true) -> PaymentProtocol {
        let payment = Payment(identifier: UUID(),
                              forSubscription: subscription,
                              date: subscription.nextPaymentDate,
                              currency: subscription.currency,
                              amount: subscription.amount)
        if isEdit {
            subscription.nextPaymentDate = add(subscription.paymentPeriod.0, subscription.paymentPeriod.1, to: subscription.nextPaymentDate)
        }
        return payment
    }
    
    private func add(_ count: Int, _ periodType: PeriodType, to date: Date) -> Date {
        var dateComponents = DateComponents()
        switch periodType {
        case .day:
            dateComponents.day = count
        case .week:
            dateComponents.day = count * 7
        case .month:
            dateComponents.month = count
        case .year:
            dateComponents.year = count
        }
        let updatedDate = Calendar.current.date(byAdding: dateComponents, to: date)
        precondition(updatedDate != nil)
        return updatedDate ?? Date()
    }
    
    fileprivate func getNewPayments(for subscription: inout SubscriptionProtocol) -> [PaymentProtocol] {
        guard isNeedCreatePayments(for: subscription) else { return [] }
        
        return []
    }
    
}
