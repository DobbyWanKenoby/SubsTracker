import UIKit
import SwiftCoordinatorsKit

class CoordinatorFactory {
    
    // MARK: Главный координатор приложения
    @discardableResult
    static func getAppCoordinator(options: [CoordinatorOption] = []) -> AppCoordinator {
        return AppCoordinator(options: options)
    }
    
    // MARK: Координатор сцены
    @discardableResult
    static func getSceneCoordinator(appCoordinator: AppCoordinator, window: UIWindow, options: [CoordinatorOption] = []) -> SceneCoordinator {
        return SceneCoordinator(appCoordinator: appCoordinator, window: window, options: options)
    }
    
    // MARK: - Main Flow Coordinator
    
    @discardableResult
    static func getMainFlowCoordinator(rootCoordinator: Coordinator, options: [CoordinatorOption] = []) -> MainFlowCoordinatorProtocol {
        let controller = ControllerFactory.getDefaultController(byType: .tabBar)
        return MainFlowCoordinator(presenter: controller, rootCoordinator: rootCoordinator, options: options)
    }
    
    // MARK: - Presenters
    
    @discardableResult
    static func getInitializatorCoordinator(rootCoordinator: Coordinator?, options: [CoordinatorOption] = []) -> InitializatorCoordinatorProtocol {
        let controller = ControllerFactory.getInitializatorController()
        return InitializatorCoordinator(presenter: controller, rootCoordinator: rootCoordinator, options: options)
    }
    
    @discardableResult
    static func getFunctionalCoordinator(rootCoordinator: Coordinator?, options: [CoordinatorOption] = []) -> FunctionalCoordinatorProtocol {
        let controller = ControllerFactory.getFunctionalController()
        return FunctionalCoordinator(presenter: controller, rootCoordinator: rootCoordinator, options: options)
    }
    
    @discardableResult
    static func getAddSubscriptionCoordinator(rootCoordinator: Coordinator?, options: [CoordinatorOption] = []) -> AddSubscriptionCoordinatorProtocol {
        let controller = ControllerFactory.getAddSubscriptionBaseController()
        return AddSubscriptionCoordinator(presenter: controller, rootCoordinator: rootCoordinator, options: options)
    }
    
    @discardableResult
    static func getSubscriptionListCoordinator(rootCoordinator: Coordinator?, options: [CoordinatorOption] = []) -> SubscriptionListCoordinatorProtocol {
        let сontroller = ControllerFactory.getSubscriptionListBaseController()
        return SubscriptionListCoordinator(presenter: сontroller, rootCoordinator: rootCoordinator, options: options)
    }

    
    // MARK: - MicroServices Coordinators
    
    @discardableResult
    static func getSettingMicroService(rootCoordinator: Coordinator?, options: [CoordinatorOption] = []) -> SettingCoordinatorProtocol {
        return SettingCoordinator(rootCoordinator: rootCoordinator, options: options)
    }
    
    @discardableResult
    static func getCurrencyMicroService(rootCoordinator: Coordinator?, options: [CoordinatorOption] = []) -> CurrencyCoordinatorProtocol {
        return CurrencyCoordinator(rootCoordinator: rootCoordinator, options: options)
    }
    
    @discardableResult
    static func getServiceMicroService(rootCoordinator: Coordinator?, options: [CoordinatorOption] = []) -> ServiceCoordinatorProtocol {
        return ServiceCoordinator(rootCoordinator: rootCoordinator, options: options)
    }
    
    @discardableResult
    static func getPaymentMicroService(rootCoordinator: Coordinator?, options: [CoordinatorOption] = []) -> PaymentsCoordinatorProtocol {
        return PaymentsCoordinator(rootCoordinator: rootCoordinator, options: options)
    }
    
    @discardableResult
    static func getCoreDataMicroService(rootCoordinator: Coordinator?, options: [CoordinatorOption] = []) -> CoreDataCoordinatorProtocol {
        return CoreDataCoordinator(rootCoordinator: rootCoordinator, options: options)
    }
    
    @discardableResult
    static func getSubscriptionMicroService(rootCoordinator: Coordinator?, options: [CoordinatorOption] = []) -> SubscriptionCoordinatorProtocol {
        return SubscriptionCoordinator(rootCoordinator: rootCoordinator, options: options)
    }

}
