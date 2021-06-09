// Сервис, обеспечивающий работу с сущностью "Валюта/Currency"

import UIKit
import CoreData


protocol CurrencyStorageCoordinatorProtocol: BaseCoordinator, Transmitter, Receiver {}

class CurrencyStorageCoordinator: BaseCoordinator, CurrencyStorageCoordinatorProtocol {
    
    // MARK: - CoreData
    
    lazy var context: NSManagedObjectContext = {
        let signalAnswer = broadcast(signalWithReturnAnswer: CoreDataSignal.getDefaultContext).first as! CoreDataSignal
        if case CoreDataSignal.context(let context) = signalAnswer {
            return context
        } else {
            fatalError("Can't get a Core Data context during app initialization process")
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
    
    private func createUpdateIfNeeded(from currency: CurrencyProtocol) {
        let a = CurrencyEntity.getEntity(from: currency, context: context)
        savePersistance()
    }
    
    func receive(signal: Signal) -> Signal? {
        switch signal {
        
        // создание/обновление Валюты
        case CurrencySignal.createUpdateIfNeeded(let currencies):
            currencies.forEach{ currency in
                createUpdateIfNeeded(from: currency)
//                if getCurrencyEntityBy(identifier: currency.identifier) == nil {
//                    self.create(currency: currency)
//                } else {
//                    self.update(currency: currency)
//                }
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
    
    // получение списка Валюты
    private func loadCurrencies() -> [CurrencyProtocol] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrencyEntity")

        do {
            let currencies = try context.fetch(fetchRequest)
            var resultCurrenciesArray = [Currency]()
            for currency in currencies {
                guard let newCurrency = (currency as? CurrencyEntity)?.convertToCurrencyInstance() as? Currency else {
                    continue
                }
                resultCurrenciesArray.append(newCurrency)
            }
            return resultCurrenciesArray
        } catch {
            fatalError("Error during load Currency by identifier. Error message: \(error)")
        }
    }
    
    // создание Валюты
    private func create(currency: CurrencyProtocol) {
        let _ = CurrencyEntity.createInstance(from: currency, context: context)
        savePersistance()
    }
    
    // обновление Валюты
    // поиск происходит по идентификатору (identifier)
    private func update(currency: CurrencyProtocol) {
        // если у валюты стоит флаг isCurrent, то необходимо обеспечить его уникальность
        if currency.isCurrent {
            while let currentCurrencyEntity = getCurrentCurrencyEntity() {
                currentCurrencyEntity.isCurrent = false
            }
        }
        // далее обновляем текущую валюту
        let currencyEntity = getCurrencyEntityBy(identifier: currency.identifier)
        currencyEntity?.updateProperties(withCurrency: currency)
        savePersistance()
    }
    
    // MARK: Поиск Валюты
    private func getCurrencyBy(identifier: String) -> CurrencyProtocol? {
        return getCurrencyEntityBy(identifier: identifier)?.convertToCurrencyInstance()
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
        return getCurrentCurrencyEntity()?.convertToCurrencyInstance()
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
