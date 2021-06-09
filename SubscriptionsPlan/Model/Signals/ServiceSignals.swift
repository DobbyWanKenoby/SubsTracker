//
// Данные о действиях над сущностью "Сервис"
//

import UIKit

enum ServiceSignal: Signal {
    
    // загрузка сервисов
    case getServiceByIdentifier(String)
    case load(type: ServicesLoadingType)
    
    // передача сервисов
    case service(ServiceProtocol)
    case services([ServiceProtocol])
    
    // сохранение сервисов в долговременно хранилище
    // создание нового или обновление существующего сервиса
    case createUpdateIfNeeded(services: [ServiceProtocol])
    
}

@frozen
enum ServicesLoadingType {
    case all
    case `default`
    case custom
}
