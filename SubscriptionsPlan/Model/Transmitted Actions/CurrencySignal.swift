//
// Данные о действиях над сущностью "Валюта"
//

enum CurrencySignal: Signal {
    case load
    case actualCurrencies (currencies: [CurrencyProtocol])
}
