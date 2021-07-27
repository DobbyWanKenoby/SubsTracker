import SwiftCoordinatorsKit

class CoordinatorFactory {
    
    // MARK: - Main App Coordinator
    
    @discardableResult
    static func getApplicationCoordinator() -> ApplicationCoordinatorProtocol {
        let controller = ControllerFactory.getDefaultController(byType: .tabBar)
        return ApplicationCoordinator(presenter: controller)
    }
    
    // MARK: - Presenters
    
    @discardableResult
    static func getInitializatorCoordinator(rootCoordinator: Coordinator?) -> InitializatorCoordinatorProtocol {
        let controller = ControllerFactory.getInitializatorController()
        return InitializatorCoordinator(presenter: controller, rootCoordinator: rootCoordinator)
    }
    
    @discardableResult
    static func getIFunctionalCoordinator(rootCoordinator: Coordinator?) -> FunctionalCoordinatorProtocol {
        let controller = ControllerFactory.getFunctionalController()
        return FunctionalCoordinator(presenter: controller, rootCoordinator: rootCoordinator)
    }
    
    @discardableResult
    static func getAddSubscriptionCoordinator(rootCoordinator: Coordinator?) -> AddSubscriptionCoordinatorProtocol {
        let controller = ControllerFactory.getAddSubscriptionBaseController()
        return AddSubscriptionCoordinator(presenter: controller, rootCoordinator: rootCoordinator)
    }
    
    @discardableResult
    static func getSubscriptionListCoordinator(rootCoordinator: Coordinator?) -> SubscriptionListCoordinatorProtocol {
        let сontroller = ControllerFactory.getSubscriptionListBaseController()
        return SubscriptionListCoordinator(presenter: сontroller, rootCoordinator: rootCoordinator)
    }

    
    // MARK: - MicroServices Coordinators
    
    @discardableResult
    static func getSettingMicroService(rootCoordinator: Coordinator?) -> SettingCoordinatorProtocol {
        return SettingCoordinator(rootCoordinator: rootCoordinator)
    }
    
    @discardableResult
    static func getCurrencyMicroService(rootCoordinator: Coordinator?) -> CurrencyCoordinatorProtocol {
        return CurrencyCoordinator(rootCoordinator: rootCoordinator)
    }
    
    @discardableResult
    static func getServiceMicroService(rootCoordinator: Coordinator?) -> ServiceCoordinatorProtocol {
        return ServiceCoordinator(rootCoordinator: rootCoordinator)
    }
    
    @discardableResult
    static func getPaymentMicroService(rootCoordinator: Coordinator?) -> PaymentsCoordinatorProtocol {
        return PaymentsCoordinator(rootCoordinator: rootCoordinator)
    }
    
    @discardableResult
    static func getCoreDataMicroService(rootCoordinator: Coordinator?) -> CoreDataCoordinatorProtocol {
        return CoreDataCoordinator(rootCoordinator: rootCoordinator)
    }
    
    @discardableResult
    static func getSubscriptionMicroService(rootCoordinator: Coordinator?) -> SubscriptionCoordinatorProtocol {
        return SubscriptionCoordinator(rootCoordinator: rootCoordinator)
    }

}
