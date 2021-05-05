import UIKit

// MARK: - Kit Coordinator

class BaseCoordinator: Coordinator, Presenter {
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
        }
    }
    
    func startFlow() {}
    func finishFlow() {}
}
