//
//  PaymentSignals.swift
//  SubscriptionsPlan
//
//  Created by Admin on 09.07.2021.
//

import Foundation
import SwiftCoordinatorsKit

enum PaymentSignal: Signal {
    // создание новой/обновление существующей записи о платеже
    case createUpdate(payment: [PaymentProtocol])
    // создание платежей для подписки
    case createPayments(count: Int, forSubscription: SubscriptionProtocol, editSubscription: Bool = true)
}
