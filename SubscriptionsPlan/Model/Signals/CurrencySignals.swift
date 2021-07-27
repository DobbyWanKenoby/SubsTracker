//
// Данные о действиях над сущностью "Валюта"
//

import SwiftCoordinatorsKit

enum CurrencySignal: Signal {
    
    // сохранение валюты в долговременно хранилище
    // создание новой или обновление существующей записи
    case createUpdateIfNeeded(currencies: [CurrencyProtocol])
    
    // получение валют
    case getCurrencies
    case getDefaultCurrency
    
    // передача списка валют
    case currencies([CurrencyProtocol])
    case currency(CurrencyProtocol)
}
