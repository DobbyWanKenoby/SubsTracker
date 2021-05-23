import UIKit

// MARK: - Template Coordinators

class BaseCoordinator: Coordinator {
    var rootCoordinator: Coordinator? = nil
    var childCoordinators: [Coordinator] = []
    var finishCompletion: (() -> Void)? = nil
    @discardableResult
    required init(rootCoordinator: Coordinator? = nil) {
        if let rootCoordinator = rootCoordinator {
            self.rootCoordinator = rootCoordinator
            self.rootCoordinator?.childCoordinators.append(self)
        }
    }
    
    func startFlow(finishCompletion: (() -> Void)? = nil) {
        self.finishCompletion = finishCompletion
    }
    
    func finishFlow() {
        self.finishCompletion?()
        self.rootCoordinator?.removeChild(coordinator: self)
    }
}

class BasePresenter: BaseCoordinator, Presenter {
    var childControllers: [UIViewController] = []
    var presenter: UIViewController?
    required init(presenter: UIViewController?, rootCoordinator: Coordinator? = nil) {
        super.init(rootCoordinator: rootCoordinator)
        if let presenter = presenter {
            self.presenter = presenter
        }
    }
    
    @discardableResult required init(rootCoordinator: Coordinator? = nil) {
        fatalError("init(rootCoordinator:) has not been implemented")
    }
}
