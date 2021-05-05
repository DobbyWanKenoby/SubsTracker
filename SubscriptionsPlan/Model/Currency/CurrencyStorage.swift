//
//  CurrencyStorage.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 05.01.2021.
//

import Foundation

// MARK: - Service Storage Data Layer

/// Протокол, описывающий реализацию хранилища сущностей "Валюта", работающую с конкретным типом хранилища
protocol CurrencyStorageDataLayerProtocol {
    func getAll() -> [CurrencyProtocol]
}

/// Локальное хранилище сущностей "Валюта"
class CurrencyLocalStorage: CurrencyStorageDataLayerProtocol {
    var currencies: [CurrencyProtocol] = [
        Currency(identifier: "eur", symbol: "€", title: "EUR"),
        Currency(identifier: "usd", symbol: "$", title: "USD"),
        Currency(identifier: "rub", symbol: "₽", title: "RUB"),
        Currency(identifier: "uah", symbol: "₴", title: "UAH")
    ]
    
    func getAll() -> [CurrencyProtocol] {
        return currencies
    }
}

// MARK: - Service Storage Front Layer

class CurrencyStorage {
    static var `default`: CurrencyStorageDataLayerProtocol {
        self.local
    }
    static var local: CurrencyStorageDataLayerProtocol  = CurrencyLocalStorage()
}
