//
//  Payment.swift
//  SubscriptionsPlan
//
//  Created by Admin on 01.07.2021.
//

import Foundation

protocol PaymentProtocol {
    var identifier: UUID { get }
    var service: ServiceProtocol { get }
    var subscriptionIdentifier: String { get }
    var date: Date { get }
    var currency: CurrencyProtocol { get }
    var amount: Decimal { get set }
    init(identifier: UUID, forSubscription: SubscriptionProtocol, date: Date, currency: CurrencyProtocol, amount: Decimal)
}

struct Payment: PaymentProtocol {
    
    var identifier: UUID
    var service: ServiceProtocol
    var subscriptionIdentifier: String
    var date: Date
    var currency: CurrencyProtocol
    var amount: Decimal
    
    init(identifier: UUID, forSubscription: SubscriptionProtocol, date: Date, currency: CurrencyProtocol, amount: Decimal) {
        self.identifier = identifier
        self.subscriptionIdentifier = forSubscription.identifier.uuidString
        self.service = forSubscription.service
        self.currency = currency
        self.amount = amount
        self.date = date
    }
    
}
