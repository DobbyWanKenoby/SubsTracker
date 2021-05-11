//
//  Currency.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 05.01.2021.
//

import Foundation

protocol CurrencyProtocol {
    var identifier: String { get set }
    var symbol: String { get set }
    var title: String { get set }
}

struct Currency: CurrencyProtocol {
    var identifier: String
    var symbol: String
    var title: String
}
