//
//  InitializatorCoordinator.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 23.05.2021.
//

import UIKit
import CoreData

protocol InitializatorCoordinatorProtocol: BasePresenter, Transmitter {}

class InitializatorCoordinator: BasePresenter, InitializatorCoordinatorProtocol {
    
    // дефолтная валюта
    // свойство используется, чтобы сохранить ранее установленную дефолтную валюту
    lazy private var defaultCurrency: CurrencyProtocol? = {
        let currencySignal = CurrencySignal.getDefaultCurrency
        if let signalAnswer = self.broadcast(signalWithReturnAnswer: currencySignal).first,
           case CurrencySignal.currency(let currency) = signalAnswer {
            return currency
        } else {
            return nil
        }
    }()
    
    // флаг необходимости проведения инициализации
    lazy var isInitializationNeed: Bool = {
       return true
    }()
    
    // MARK: - Coordinator Life Cycle
    
    override func startFlow(finishCompletion: (() -> Void)? = nil) {
        super.startFlow(finishCompletion: finishCompletion)
        (self.presenter as? InitializatorControllerProtocol)?.initializationDidEnd = {
            self.finishFlow()
        }
        
        // проводим инициализацию
        if isInitializationNeed {
            transitionServicesToStorage()
            transitionCurrenciesToStorage()
        }
        
//        let signal = ServiceSignal.load(type: .all)
//        let a = self.broadcast(signalWithReturnAnswer: signal)
//        print(a)
//
//        let signal2 = CurrencySignal.getCurrencies
//        let b = self.broadcast(signalWithReturnAnswer: signal2)
//        print(b)
//
//        print(Locale.current.identifier)
    }
    
    // перенос данных о Валютах из временного хранилища в основное
    private func transitionCurrenciesToStorage() {
        guard let path = Bundle.main.path(forResource: "Currencies", ofType: "plist") else {
            return
        }
        
        let currenciesFromDefaultFile = NSArray(contentsOfFile: path) as! [[String : Any]]
        var currencies = [Currency]()
        for defaultCurrencyItem in currenciesFromDefaultFile {
            // получаем исходные данные Валюты
            guard let identifier = (defaultCurrencyItem["identifier"] as? String)?.lowercased() else {
                continue
            }
            guard let symbol = defaultCurrencyItem["symbol"] as? String else {
                continue
            }
            let isLocalizableTitle = (defaultCurrencyItem["isLocalizableTitle"] as? Bool) ?? false
            let title: String = {
                let titleIdentifier = (defaultCurrencyItem["title"] as? String) ?? identifier
                if isLocalizableTitle {
                    return NSLocalizedString("currency_\(titleIdentifier)", comment: "")
                }
                return defaultCurrencyItem["identifier"] as! String
            }()
            
            var isDefault: Bool = false
            if let defaultCurrency = self.defaultCurrency, defaultCurrency.identifier == identifier {
                isDefault = true
            }
            
            var addedCurrency = Currency(identifier: identifier, symbol: symbol, title: title)
            addedCurrency.isCurrent = isDefault
            currencies.append(addedCurrency)
        }
        if defaultCurrency == nil {
            currencies[0].isCurrent = true
        }
        let signalForSaveCurrencies = CurrencySignal.createUpdateIfNeeded(currencies: currencies)
        self.broadcast(signal: signalForSaveCurrencies, withAnswerToReceiver: nil)
    }
    
    
    // перенос данных о Сервисах из временного хранилища в основное
    private func transitionServicesToStorage() {
        guard let path = Bundle.main.path(forResource: "Services", ofType: "plist") else {
            return
        }
        
        let defaultServices = NSArray(contentsOfFile: path) as! [[String : Any]]
        var services = [Service]()
        for defaultServiceItem in defaultServices {
            // получаем исходные данные Cервиса
            guard let identifier = (defaultServiceItem["identifier"] as? String)?.lowercased() else {
                continue
            }
            guard let colorHEX = defaultServiceItem["color"] as? String else {
                continue
            }
            let isLocalizableTitle = (defaultServiceItem["isLocalizableTitle"] as? Bool) ?? false
            let title: String = {
                let titleIdentifier = (defaultServiceItem["title"] as? String) ?? identifier
                if isLocalizableTitle {
                    return NSLocalizedString("service_\(titleIdentifier)", comment: "")
                }
                return defaultServiceItem["identifier"] as! String
            }()
            
            services.append(Service(identifier: identifier, title: title, colorHEX: colorHEX))
        }
        let signalForSaveServices = ServiceSignal.createUpdateIfNeeded(services: services)
        self.broadcast(signal: signalForSaveServices, withAnswerToReceiver: nil)
    }
    
    private func isServiceExist(withIdentifier identifier: String) -> Bool {
        let answer = broadcast(signalWithReturnAnswer: ServiceSignal.getServiceByIdentifier(identifier))
        if answer.count > 0 {
            return true
        }
        return false
    }

}
