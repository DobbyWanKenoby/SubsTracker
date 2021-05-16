import UIKit

// MARK: - Template Coordinators

class BaseCoordinator: Coordinator {
    var rootCoordinator: Coordinator? = nil
    var childCoordinators: [Coordinator] = []
    var childControllers: [UIViewController] = []
    required init(rootCoordinator: Coordinator? = nil) {
        if let rootCoordinator = rootCoordinator {
            self.rootCoordinator = rootCoordinator
            self.rootCoordinator?.childCoordinators.append(self)
        }
    }
    
    func startFlow() {}
    func finishFlow() {}
}

class BasePresenter: Coordinator, Presenter {
    var rootCoordinator: Coordinator? = nil
    var childCoordinators: [Coordinator] = []
    var childControllers: [UIViewController] = []
    var presenter: UIViewController?
    required init(presenter: UIViewController?, rootCoordinator: Coordinator? = nil) {
        if let presenter = presenter {
            self.presenter = presenter
        }
        if let rootCoordinator = rootCoordinator {
            self.rootCoordinator = rootCoordinator
            self.rootCoordinator?.childCoordinators.append(self)
        }
    }
    
    func startFlow() {}
    func finishFlow() {}
}
