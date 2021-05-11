//
// Данные о действиях над сущностью "Сервис"
//

protocol ServiceActionProtocol: ActionData {}

enum ServiceAction: ServiceActionProtocol {
    
    case load(type: ServiceType)
    case result(service: [ServiceProtocol])
    
    enum ServiceType {
        case all
        case `default`
    }
}
