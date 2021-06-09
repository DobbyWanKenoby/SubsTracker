//
// Данные о действиях над сущностью "Сервис"
//

import UIKit

enum ServiceSignal: Signal {
    
    case load(type: ServiceType)
    case actualServices(services: [ServiceProtocol])
    
    enum ServiceType {
        case all
        case `default`
    }
}

extension UIColor: NSSecureCoding {
    
}

extension UIImage: NSSecureCoding {}
