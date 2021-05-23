//
// Данные о действиях над сущностью "Сервис"
//

enum ServiceSignal: Signal {
    
    case load(type: ServiceType)
    case actualServices(services: [ServiceProtocol])
    
    enum ServiceType {
        case all
        case `default`
    }
}
