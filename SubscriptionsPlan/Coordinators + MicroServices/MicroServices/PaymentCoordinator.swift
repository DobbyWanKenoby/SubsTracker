//
//  SubscriptionHandlerCoordinator.swift
//  SubscriptionsPlan
//
//  Created by Admin on 01.07.2021.
//

import Foundation
import CoreData

protocol PaymentsCoordinatorProtocol: BaseCoordinator, Transmitter, Receiver {}

class PaymentsCoordinator: BaseCoordinator, PaymentsCoordinatorProtocol {
    
    // MARK: CoreData
    
    lazy var context: NSManagedObjectContext = {
        let signalAnswer = broadcast(signalWithReturnAnswer: CoreDataSignal.getDefaultContext).first as! CoreDataSignal
        if case CoreDataSignal.context(let context) = signalAnswer {
            return context
        } else {
            fatalError("Can't get a Core Data context in Payment Coordinator")
        }
    }()
    
    func savePersistance() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error during saving Payments to Storage. Error message: \(error)")
            }
        }
    }
    
}

// MARK: - Coordinator Logic

extension PaymentsCoordinator {
    
    func receive(signal: Signal) -> Signal? {
        switch signal {
        case SubscriptionSignal.checkSubscriptionOnPayments(var subscription):
            if isNeedCreatePayments(for: subscription) {
                let payments = getNewPayments(for: &subscription)
                //
                // ...
                //
            }
        case PaymentSignal.createPayments(count: let count, forSubscription: var subscription, editSubscription: let isEdit):
            for _ in 1...count {
                let payment = getNextPayment(for: &subscription, addPeriodToNextPaymentDate: isEdit)
                self.createUpdate(from: payment)
            }
            if isEdit {
                let signal = SubscriptionSignal.createUpdate(subscriptions: [subscription], broadcastActualSubscriptionsList: false)
                self.broadcast(signal: signal, withAnswerToReceiver: nil)
            }
        default:
            break
        }
        return nil
    }
    
    func edit(signal: Signal) -> Signal {
        var updatedSignal = signal
        
        // С помощью обработки этого сигнала координатор перехватывает данные о подписках
        // и заменяет данные о сроке следующего платеже + создает записи о проведенных платежах
        if case SubscriptionSignal.createUpdate(subscriptions: var subscriptions, broadcastActualSubscriptionsList: let broadcast) = signal {
            for var (subscriptionIndex, subscriptionItem) in subscriptions.enumerated() {
                while isNeedCreatePayments(for: subscriptionItem) {
                    let nextPayment = getNextPayment(for: &subscriptionItem, addPeriodToNextPaymentDate: true)
                    createUpdate(from: nextPayment)
                }
                subscriptions[subscriptionIndex] = subscriptionItem
            }
            updatedSignal = SubscriptionSignal.createUpdate(subscriptions: subscriptions, broadcastActualSubscriptionsList: broadcast)
        } else if case PaymentSignal.createUpdate(let payments) = signal {
            payments.forEach{ paymentItem in
                self.createUpdate(from: paymentItem)
            }
        }
        
        return updatedSignal
    }
}

// MARK: - Payments Storage Logic

extension PaymentsCoordinator {
    
    fileprivate func createUpdate(from payment: PaymentProtocol) {
        PaymentEntity.getEntity(from: payment, context: context, updateEntityPropertiesIfNeeded: true)
        savePersistance()
    }
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
    fileprivate func getNextPayment(for subscription: inout SubscriptionProtocol, addPeriodToNextPaymentDate isEdit: Bool = true) -> PaymentProtocol {
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
