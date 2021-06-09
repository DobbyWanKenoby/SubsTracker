//
//  CurrencyEntity+CoreDataClass.swift
//  SubscriptionsPlan
//
//  Created by Admin on 03.06.2021.
//
//

import Foundation
import CoreData

protocol EntityInstanceProvider {
    /// связанный с данным Entity тип модели
    associatedtype AssociatedInstanceType
    /// вовзращает Entity, соответсвующий переданному from
    /// создает новый Entity или получает существующий из базы
    static func getEntity(from: AssociatedInstanceType, context: NSManagedObjectContext) -> Self
    /// обновить все свойства Entity в соответствии с Instances
    func updateEntity(from: AssociatedInstanceType)
    /// Преобразовать Entity в Instance
    func convertEntityToInstance() -> AssociatedInstanceType
}

@objc(CurrencyEntity)
public final class CurrencyEntity: NSManagedObject, EntityInstanceProvider {
    
    typealias AssociatedInstanceType = CurrencyProtocol
    
    static func getEntity(from currency: CurrencyProtocol, context: NSManagedObjectContext) -> Self {
        let fetch = NSFetchRequest<CurrencyEntity>(entityName: "CurrencyEntity")
        print(currency.identifier)
        fetch.predicate = NSPredicate(format: "identifier = %@", currency.identifier)
        fetch.fetchBatchSize = 1
        guard let currenciesFromStorage = try? context.fetch(fetch),
              let currencyFromStorage = currenciesFromStorage.first else {
            let currencyEntity = CurrencyEntity(context: context)
            currencyEntity.updateEntity(from: currency)
            return currencyEntity as! Self
        }
        return currencyFromStorage as! Self
    }
    
    func updateEntity(from currency: CurrencyProtocol) {
        self.identifier = currency.identifier
        self.title = currency.title
        self.symbol = currency.symbol
        self.isCurrent = currency.isCurrent
    }
    
    func convertEntityToInstance() -> CurrencyProtocol {
        Currency(identifier: "asd", symbol: "asd", title: "asd")
    }
    
    static func createInstance(from currency: CurrencyProtocol, context: NSManagedObjectContext) -> CurrencyEntity {
        let currencyEntity = CurrencyEntity(context: context)
        currencyEntity.identifier = currency.identifier
        currencyEntity.title = currency.title
        currencyEntity.symbol = currency.symbol
        currencyEntity.isCurrent = currency.isCurrent
        return currencyEntity
    }

    func updateProperties(withCurrency currency: CurrencyProtocol) {
        self.identifier = currency.identifier
        self.title = currency.title
        self.symbol = currency.symbol
        self.isCurrent = currency.isCurrent
    }

    func convertToCurrencyInstance() -> CurrencyProtocol {
        let currency = Currency(identifier: self.identifier!, symbol: self.symbol!, title: self.title!, isCurrent: self.isCurrent)
        return currency
    }
}
