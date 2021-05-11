// Сервис, обеспечивающий работу с сущностью "Валюта/Currency"

import UIKit

protocol CurrencyStorageCoordinatorProtocol: BaseCoordinator, ActionService {}

class CurrencyStorageCoordinator: BaseCoordinator, CurrencyStorageCoordinatorProtocol {
    func handle(data: Any) -> Any? {
        if case CurrencyAction.load = data {
            return self.getCurrencies()
        }
        return nil
    }
}

// MARK: Работа с хранилищем Валют

extension CurrencyStorageCoordinator {
    private func getCurrencies() -> [CurrencyProtocol] {
        // загрузка стандартных сервисов из Plist-файла
        let currenciesDictionary: [[String:String]]
        guard let path = Bundle.main.path(forResource: "Currencies", ofType: "plist") else {
            return []
        }
        currenciesDictionary = NSArray(contentsOfFile: path) as! [[String : String]]
        var currencies: [CurrencyProtocol] = []
        currenciesDictionary.forEach { serviceItemFromPlistFile in
            let identifier = (serviceItemFromPlistFile["identifier"]!).lowercased()
            let title: String
            if serviceItemFromPlistFile["isLocalizable"]! == "1" {
                title = NSLocalizedString("currency_\(identifier)", comment: "")
            } else {
                title = (serviceItemFromPlistFile["identifier"]!)
            }
            let symbol = (serviceItemFromPlistFile["symbol"]!).uppercased()
            
            currencies.append(Currency(identifier: identifier, symbol: symbol, title: title))
        }
        return currencies
    }
}
