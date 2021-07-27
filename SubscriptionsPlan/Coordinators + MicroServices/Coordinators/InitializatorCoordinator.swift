//
//  InitializatorCoordinator.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 23.05.2021.
//

import UIKit
import CoreData
import SwiftCoordinatorsKit

protocol InitializatorCoordinatorProtocol: BasePresenter, Transmitter {}

class InitializatorCoordinator: BasePresenter, InitializatorCoordinatorProtocol {
    
    lazy private var currentAppVersion: String = {
        Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "unknownVersion"
    }()
    
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
        let signal = SettingSignal.getLastInitializationAppVersion
        guard let answerSignal = self.broadcast(signalWithReturnAnswer: signal).first as? SettingSignal, case SettingSignal.lastInitializationAppVersion(let version) = answerSignal else {
            return true
        }
        if version == currentAppVersion {
            return false
        }
        return true
    }()
    
    // MARK: - Coordinator Life Cycle
    
    override func startFlow(finishCompletion: (() -> Void)? = nil) {
        super.startFlow(finishCompletion: finishCompletion)
        (self.presenter as? InitializatorControllerProtocol)?.initializationDidEnd = {
            self.finishFlow()
        }
        // проводим инициализацию
        //if isInitializationNeed {
            transitionServicesToStorage()
            transitionCurrenciesToStorage()
            updateLastInitializationAppVersion()
        //}

    }
    
    private func updateLastInitializationAppVersion() {
        let signal = SettingSignal.updateLastInitializationAppVersion(currentAppVersion)
        _ = self.broadcast(signalWithReturnAnswer: signal)
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
            
            var addedCurrency = Currency(identifier: identifier, symbol: symbol, title: title)
            
            if isDefaultUserCurrency(addedCurrency) {
                addedCurrency.isCurrent = true
                defaultCurrency = addedCurrency
            }

            currencies.append(addedCurrency)
        }
        if defaultCurrency == nil {
            currencies[0].isCurrent = true
        }
        let signalForSaveCurrencies = CurrencySignal.createUpdateIfNeeded(currencies: currencies)
        self.broadcast(signal: signalForSaveCurrencies, withAnswerToReceiver: nil)
    }
    
    private func isDefaultUserCurrency(_ currency: CurrencyProtocol) -> Bool {
        if let _defaultCurrency = defaultCurrency {
            return currency.identifier == _defaultCurrency.identifier
        } else {
            return Locale.current.currencySymbol == currency.symbol
        }
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
