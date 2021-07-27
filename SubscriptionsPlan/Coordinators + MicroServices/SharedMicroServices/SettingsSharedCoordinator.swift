//
//  Settings.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 05.01.2021.
//

import Foundation
import SwiftCoordinatorsKit

class Settings: BaseCoordinator, Transmitter {    

    static var shared: Settings!
    
//    lazy var defaultCurrency: CurrencyProtocol = getDefaultCurrency()
    //var nilCurrency = Currency(identifier: "nil", symbol: "nil", title: "nil")
    
//    func getDefaultCurrency() -> CurrencyProtocol {
//        let currenciesLoadAction = CurrencyAction.load
//        let responsesArray = self.broadcast(data: [currenciesLoadAction], sourceCoordinator: self)
//        guard responsesArray.count > 0 else {
//            return nilCurrency
//        }
//        guard let currenciesResponseItem = responsesArray.first as? [CurrencyProtocol] else {
//            return nilCurrency
//        }
//        guard let currencyItem = currenciesResponseItem.first else {
//            return nilCurrency
//        }
//        return currencyItem
//    }
    
}
