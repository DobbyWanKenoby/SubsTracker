//
//  SubscriptionHandlerCoordinator.swift
//  SubscriptionsPlan
//
//  Created by Admin on 01.07.2021.
//

import Foundation
import CoreData
import SwiftCoordinatorsKit

protocol PaymentsCoordinatorProtocol: BaseCoordinator, Transmitter, Receiver {}

class PaymentsCoordinator: BaseCoordinator, PaymentsCoordinatorProtocol {
    var edit: ((Signal) -> Signal)?
    
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
                let subsPayments = getNewPayments(for: &subscription, addPeriodToNextPaymentDate: true)
                createUpdate(payments: subsPayments)
            }
        case PaymentSignal.createPayments(count: let count, forSubscription: var subscription, editSubscription: let isEdit):
            for _ in 1...count {
                let payment = getNextPayment(for: &subscription, addPeriodToNextPaymentDate: isEdit)
                self.createUpdate(payments: [payment])
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
            for (subscriptionIndex, var subscriptionItem) in subscriptions.enumerated() {
                let subsPayments = getNewPayments(for: &subscriptionItem, addPeriodToNextPaymentDate: true)
                print(subsPayments)
                print(subscriptionItem)
                createUpdate(payments: subsPayments)
                subscriptions[subscriptionIndex] = subscriptionItem
            }
            updatedSignal = SubscriptionSignal.createUpdate(subscriptions: subscriptions, broadcastActualSubscriptionsList: broadcast)
        } else if case PaymentSignal.createUpdate(let payments) = signal {
            payments.forEach{ paymentItem in
                self.createUpdate(payments: [paymentItem])
            }
        }
        
        return updatedSignal
    }
}

// MARK: - Payments Storage Logic

extension PaymentsCoordinator {
    
    fileprivate func createUpdate(payments: [PaymentProtocol]) {
        payments.forEach { payment in
            PaymentEntity.getEntity(from: payment, context: context, updateEntityPropertiesIfNeeded: true)
            savePersistance()
        }
    }
}

// MARK: - Payments Logic

extension PaymentsCoordinator {
    
    /// Проверяет, необходимо ли для данной подписки создавать платежи.
    /// Платежи создаются, если дата будущего платежа раньше сегодняшней даты
    fileprivate func isNeedCreatePayments(for subscription: SubscriptionProtocol) -> Bool {
        if Calendar.current.compare(Date(), to: subscription.nextPaymentDate, toGranularity: .day) == .orderedDescending {
            return true
        }
        return false
    }
    
    /// Возвращает ОДИН новый платеж для подписки. Его дата соответствует дате следующего платежа
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
    
    
    /// Добавляет указанное количество определенного периода (день, неделя ... ) к указанной дате
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
    
    /// Возвращает массив новых платежей для подписки и изменяет дату следующего платежа
    fileprivate func getNewPayments(for subscription: inout SubscriptionProtocol, addPeriodToNextPaymentDate isEdit: Bool = true ) -> [PaymentProtocol] {
        //guard isNeedCreatePayments(for: subscription) else { return [] }
        var payments: [PaymentProtocol] = []
        while isNeedCreatePayments(for: subscription) {
            let nextPayment = getNextPayment(for: &subscription, addPeriodToNextPaymentDate: isEdit)
            payments.append(nextPayment)
        }
        
        return payments
    }
    
}
