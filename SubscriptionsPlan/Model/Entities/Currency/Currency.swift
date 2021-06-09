//
//  Currency.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 05.01.2021.
//

import Foundation

protocol CurrencyProtocol {
    var identifier: String { get }
    var symbol: String { get }
    var title: String { get }
    var isCurrent: Bool { get set }
    init(identifier: String, symbol: String, title: String, isCurrent: Bool)
}

struct Currency: CurrencyProtocol {
    
    init(identifier: String, symbol: String, title: String, isCurrent: Bool = false) {
        self.identifier = identifier
        self.symbol = symbol
        self.title = title
        self.isCurrent = isCurrent
    }
    
    var identifier: String
    var symbol: String
    var title: String
    var isCurrent: Bool
}
