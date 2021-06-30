//
//  CurrencyEntity+CoreDataClass.swift
//  SubscriptionsPlan
//
//  Created by Admin on 03.06.2021.
//
//

import Foundation
import CoreData

@objc(CurrencyEntity)
public final class CurrencyEntity: NSManagedObject, EntityInstanceProvider {
    
    typealias AssociatedInstanceType = CurrencyProtocol
    
    @discardableResult
    static func getEntity(from currency: CurrencyProtocol, context: NSManagedObjectContext, updateEntityPropertiesIfNeeded: Bool = false) -> Self {
        let fetch = NSFetchRequest<CurrencyEntity>(entityName: "CurrencyEntity")
        fetch.predicate = NSPredicate(format: "identifier = %@", currency.identifier)
        fetch.fetchBatchSize = 1
        guard let currenciesFromStorage = try? context.fetch(fetch),
              let currencyFromStorage = currenciesFromStorage.first else {
            let currencyEntity = CurrencyEntity(context: context)
            currencyEntity.updateEntity(from: currency, context: context)
            return currencyEntity as! Self
        }
        if updateEntityPropertiesIfNeeded {
            currencyFromStorage.updateEntity(from: currency, context: context)
        }
        return currencyFromStorage as! Self
    }
    
    func updateEntity(from currency: CurrencyProtocol, context: NSManagedObjectContext) {
        self.identifier = currency.identifier
        self.title = currency.title
        self.symbol = currency.symbol
        self.isCurrent = currency.isCurrent
    }
    
    func convertEntityToInstance() -> CurrencyProtocol {
        let currency = Currency(identifier: self.identifier!, symbol: self.symbol!, title: self.title!, isCurrent: self.isCurrent)
        return currency
    }
}
