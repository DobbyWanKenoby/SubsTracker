//
//  SubscriptionHandlerCoordinator.swift
//  SubscriptionsPlan
//
//  Created by Admin on 01.07.2021.
//

import Foundation

protocol PaymentsCoordinatorProtocol: BaseCoordinator, Receiver {}

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
}

// MARK: - Receiver logic

extension PaymentsCoordinator {
    
    fileprivate func isNeedCreatePayments(for subscription: SubscriptionProtocol) -> Bool {
        if Date() < subscription.nextPayment.date {
            return true
        }
        return false
    }
    
    fileprivate func getNewPayments(for subscription: inout SubscriptionProtocol) -> [PaymentProtocol] {
        guard isNeedCreatePayments(for: subscription) else { return [] }
        
        return []
    }
    
}
