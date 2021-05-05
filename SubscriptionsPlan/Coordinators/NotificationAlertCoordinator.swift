////
////  NotificationAlertCoordinator.swift
////  SubscriptionsPlan
////
////  Created by Vasily Usov on 14.01.2021.
////
//
//import UIKit
//
//class NotificationAlertCoordinator: Coordinatable {
//    var rootCoordinator: Coordinatable?
//    var childCoordinators: [Coordinatable] = []
//    var childControllers: [UIViewController] = []
//    
//    var presenter: UIViewController
//    var transitionManagers: [UIViewControllerTransitioningDelegate] = []
//    
//    required init(presenter: UIViewController) {
//        self.presenter = presenter
//    }
//    
//    func start() {
//        let controller = ControllerFactory.getNotificationAlertController()
//        let localTransitionManager = AddSubsTransitionManager()
//        transitionManagers.append(localTransitionManager)
//        controller.transitioningDelegate = localTransitionManager
//        controller.modalPresentationStyle = .custom
//        presenter.present(controller, animated: true, completion: nil)
//         
//    }
//    
//    
//}
