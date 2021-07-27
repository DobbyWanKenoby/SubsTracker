// Сервис, обеспечивающий работу с сущностью "Валюта/Currency"

import UIKit
import CoreData
import SwiftCoordinatorsKit

protocol CurrencyCoordinatorProtocol: BaseCoordinator, Transmitter, Receiver {}

class CurrencyCoordinator: BaseCoordinator, CurrencyCoordinatorProtocol {
    
    // MARK: - CoreData
    
    lazy var context: NSManagedObjectContext = {
        let signalAnswer = broadcast(signalWithReturnAnswer: CoreDataSignal.getDefaultContext).first as! CoreDataSignal
        if case CoreDataSignal.context(let context) = signalAnswer {
            return context
        } else {
            fatalError("Can't get a Core Data context in Currency Coordinator")
        }
    }()
    
    func savePersistance() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error during saving Currencies to Storage. Error message: \(error)")
            }
        }
    }
    
    // MARK: - Receiver
    
    func receive(signal: Signal) -> Signal? {
        switch signal {
        
        // создание/обновление Валюты
        case CurrencySignal.createUpdateIfNeeded(let currencies):
            currencies.forEach{ currency in
                createUpdateIfNeeded(from: currency)
            }
            
        // запрос списка валют
        case CurrencySignal.getCurrencies:
            let currencies = loadCurrencies()
            let signal = CurrencySignal.currencies(currencies)
            return signal
        
        // запрос дефолтной валюты
        case CurrencySignal.getDefaultCurrency:
            guard let currency = getCurrentCurrency() else {
                return nil
            }
            let signal = CurrencySignal.currency(currency)
            return signal
            
        default:
            break
        }
        
        return nil
    }
    
    private func createUpdateIfNeeded(from currency: CurrencyProtocol) {
        CurrencyEntity.getEntity(from: currency, context: context, updateEntityPropertiesIfNeeded: true)
        savePersistance()
    }
    
    // получение списка Валюты
    private func loadCurrencies() -> [CurrencyProtocol] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrencyEntity")

        do {
            let currencies = try context.fetch(fetchRequest)
            var resultCurrenciesArray = [Currency]()
            for currency in currencies {
                guard let newCurrency = (currency as? CurrencyEntity)?.convertEntityToInstance() as? Currency else {
                    continue
                }
                resultCurrenciesArray.append(newCurrency)
            }
            return resultCurrenciesArray
        } catch {
            fatalError("Error during load Currency by identifier. Error message: \(error)")
        }
    }
    
    // MARK: Поиск Валюты
    private func getCurrencyBy(identifier: String) -> CurrencyProtocol? {
        return getCurrencyEntityBy(identifier: identifier)?.convertEntityToInstance()
    }
    
    private func getCurrencyEntityBy(identifier: String) -> CurrencyEntity? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrencyEntity")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", identifier)
        do {
            guard let currency = try context.fetch(fetchRequest).first else {
                return nil
            }
            return currency as? CurrencyEntity
        } catch {
            fatalError("Error during load CurrencyEntity with identifier \(identifier)")
        }
    }
    
    // MARK: Получение Дефолтной Валюты
    private func getCurrentCurrency() -> CurrencyProtocol? {
        return getCurrentCurrencyEntity()?.convertEntityToInstance()
    }
    
    private func getCurrentCurrencyEntity() -> CurrencyEntity? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrencyEntity")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "isCurrent = YES")
        do {
            guard let currency = try context.fetch(fetchRequest).first else {
                return nil
            }
            return currency as? CurrencyEntity
        } catch {
            fatalError("Error during load Current CurrencyEntity")
        }
    }
    
}
