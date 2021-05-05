//
//  Settings.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 05.01.2021.
//

import Foundation

class Settings {
    static var shared: Settings = Settings()
    var defaultCurrency: CurrencyProtocol = CurrencyStorage.default.getAll().first!
    
    // Загрузка всех настроек приложения
    init() {
        
    }
}
