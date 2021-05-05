//
//  UpcomingCoordinator.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 03.01.2021.
//

import UIKit

protocol AddSubscriptionCoordinatorProtocol: BasePresenter {}

class AddSubscriptionCoordinator: BasePresenter, AddSubscriptionCoordinatorProtocol {
    private var navigationPresenter: UINavigationController? {
        return presenter as? UINavigationController
    }
    
    // strong ссылки на менеджеры перехода
    var transitionManagers: [UIViewControllerTransitioningDelegate] = []
    var inputDataAddSubController: AddSubscriptionElement?
    
    override func startFlow() {
        navigationPresenter?.navigationBar.prefersLargeTitles = true
        navigationPresenter?.pushViewController(getServiceListConfiguredController(), animated: false)
    }
    
    private func getServiceListConfiguredController() -> UIViewController {
        let servicesListController = ControllerFactory.getServiceListController()
        
        let loadRequest = LoadServicesRequest(type: .all)
        let transmittedData = [loadRequest]
        let response = self.transmit(data: transmittedData, sourceCoordinator: self)
        print(response)
        
        
        childControllers.append(servicesListController)
        servicesListController.onSelectService = { [self] (service, selectedCell) in
            // Настройки анимации перехода
            // глобальные координаты выбранной ячейки
            // будут использоваться для корректной анимации кастомного перехода к новому view controller
            let globalPoint = selectedCell.contentView.superview?.convert(selectedCell.contentView.frame.origin, to: nil)
            let transitionManager = AddSubsTransitionManager()
            transitionManager.startPoint = globalPoint
            self.transitionManagers.append(transitionManager)
            let nextController = getAddSubConfiguredController(service: service, transitionManager: transitionManager)
            presenter!.present(nextController, animated: true, completion: nil)
        }

        let services = ServiceStorage.default.getAll(withCustoms: false)
        servicesListController.services = services
        return servicesListController
    }

    private func getAddSubConfiguredController(service: ServiceProtocol, transitionManager: UIViewControllerTransitioningDelegate?) -> UIViewController {
        let addSubController = ControllerFactory.getAddSubscriptionController()

        if self.inputDataAddSubController == nil {
            self.inputDataAddSubController = getDefaultAddSubControllerInputData(for: service)
        } else {
            self.inputDataAddSubController!.service = service
        }

        addSubController.subscription = inputDataAddSubController!

        if let transition = transitionManager {
            addSubController.transitioningDelegate = transition
            addSubController.modalPresentationStyle = .custom
        }

        addSubController.onCancelScene = { inputData in
            addSubController.dismiss(animated: true, completion: nil)
            self.inputDataAddSubController = inputData
        }

        addSubController.onSaveSubscription = { [self] inputData in
            addSubController.dismiss(animated: true, completion: nil)

            // Уведомление
            let controller = ControllerFactory.getNotificationAlertController()
            controller.text = NSLocalizedString("sub created", comment: "")
            controller.image = UIImage(systemName: "checkmark.circle.fill")!
            let localTransitionManager = NotificationAlertTransitionManager()
            transitionManagers.append(localTransitionManager)
            controller.transitioningDelegate = localTransitionManager
            controller.modalPresentationStyle = .custom
            presenter!.present(controller, animated: true, completion: nil)

            //self.inputDataAddSubController = getDefaultAddSubControllerInputData(for: service)
            
            // передача новой подписки
            let newSubscription = Subscription(
                identifier: nil,
                service: inputData.service,
                amount: inputData.amount,
                currency: inputData.currency,
                description: inputData.notice,
                nextPaymentDate: inputData.date,
                paymentPeriod: inputData.paymentPeriod)
            Subscription.save(newSubscription)
            
            let newSubs = NewSubscription(subscription: newSubscription)
            let transmittingData = [newSubs]
            transmit(data: transmittingData, sourceCoordinator: self)
//            let transferData = UpdateDataSubscriptionListInstance(updatedData: actualSubscriptions)
//            transferUpdatedData(transferData, from: self)
      
        }

        return addSubController
    }
}

// MARK: - Transmitter

extension AddSubscriptionCoordinator: Transmitter {
    func useInThisTransmitter(data: TransmittedData) {
        return
    }
}

