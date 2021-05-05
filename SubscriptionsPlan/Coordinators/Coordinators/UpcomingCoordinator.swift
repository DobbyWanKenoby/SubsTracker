////
////  UpcomingCoordinator.swift
////  SubscriptionsPlan
////
////  Created by Vasily Usov on 03.01.2021.
////
//
//import UIKit
//
//class UpcomingCoordinator: Coordinatable, UpdatableData {
//    var rootCoordinator: Coordinatable?
//    var childCoordinators: [Coordinatable] = []
//    var childControllers: [UIViewController] = []
//    var presenter: UIViewController
//    
//    required init(presenter: UIViewController) {
//        self.presenter = presenter
//    }
//    
//    func start() {
//        guard let navigationPresenter = (presenter as? UINavigationController) else {
//            return
//        }
//        let controller = ControllerFactory.getUpcomingController()
//        childControllers.append(controller)
//        let inputData = UpcomingControllerInputDataElements(subscriptions: (UIApplication.shared.delegate as! AppDelegate).subscriptions)
//        controller.inputData = inputData
//        navigationPresenter.pushViewController(controller, animated: false)
//    }
//    
//    // Transferable & Updatable
//    
//    func updateData(_ instance: UpdateData) {
//        if instance.updatedData is SubscriptionsList {
//            updateSubscriptionList(subscriptions: instance.updatedData as! SubscriptionsList)
//        }
//    }
//    
//    private func updateSubscriptionList(subscriptions: SubscriptionsList) {
//        childControllers.forEach{ controller in
//            (controller as? UpcomingTransferInterface)?.inputData.subscriptions = subscriptions
//        }
//    }
//    
//    
//    
//}
