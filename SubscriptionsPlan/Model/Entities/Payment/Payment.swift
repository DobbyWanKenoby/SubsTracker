//
//  Payment.swift
//  SubscriptionsPlan
//
//  Created by Admin on 01.07.2021.
//

import Foundation

protocol PaymentProtocol {
    var identifier: String { get }
    var forSubscription: SubscriptionProtocol { get }
    var currency: CurrencyProtocol { get }
    var amount: Float { get set }
    init(identifier: String, forSubscription: SubscriptionProtocol, currency: CurrencyProtocol, amount: Float)
}

struct Payment: PaymentProtocol {
    var identifier: String
    
    var forSubscription: SubscriptionProtocol
    
    var currency: CurrencyProtocol
    
    var amount: Float
    
    init(identifier: String, forSubscription: SubscriptionProtocol, currency: CurrencyProtocol, amount: Float) {
        self.identifier = identifier
        self.forSubscription = forSubscription
        self.currency = currency
        self.amount = amount
    }
    

}
