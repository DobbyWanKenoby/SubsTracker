//
//  UpcomingCoordinator.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 03.01.2021.
//

import UIKit

protocol AddSubscriptionCoordinatorProtocol: BasePresenter, Transmitter, Receiver {}

class AddSubscriptionCoordinator: BasePresenter, AddSubscriptionCoordinatorProtocol {
    
    private var navigationPresenter: UINavigationController? {
        return presenter as? UINavigationController
    }
    
    // strong ссылки на менеджеры перехода
    var transitionManagers: [UIViewControllerTransitioningDelegate] = []
    
    override func startFlow(finishCompletion: (() -> Void)? = nil) {
        super.startFlow(finishCompletion: finishCompletion)
        navigationPresenter?.navigationBar.prefersLargeTitles = true
        navigationPresenter?.pushViewController(getServiceListConfiguredController(), animated: false)
    }
    
    // Возвращает готовый контроллер со списком Сервисов
    private func getServiceListConfiguredController() -> UIViewController {
        let servicesListController = ControllerFactory.getServiceListController()
        
        childControllers.append(servicesListController)
        servicesListController.onSelectService = { [self] (service, selectedCell) in
            // Настройки анимации перехода
            // глобальные координаты выбранной ячейки
            // будут использоваться для корректной анимации кастомного перехода к экрану создания подписки
            let globalPoint = selectedCell.contentView.superview?.convert(selectedCell.contentView.frame.origin, to: nil)
            
            let routeTransitionData = AddSubsTransitionData(startGlobalPoint: globalPoint,
                                                          startLocalPoint: selectedCell.frame.origin,
                                                          startSize: selectedCell.frame.size,
                                                          cellView: selectedCell,
                                                          cellRootView: selectedCell.superview)
            let transitionManager = AddSubsTransitionManager(transitionData: routeTransitionData)
            self.transitionManagers.append(transitionManager)
            // контроллер, к которому будет происходить переход
            let nextController = getAddSubConfiguredController(service: service, transitionManager: transitionManager)
            self.route(from: presenter!, to: nextController, method: .custom(transitionManager))
        }
        
        // Загрузка сервисов
        // обрабатываются полученные сервисы в методе receive контроллера со списком сервисов
        let servicesSignal = ServiceSignal.load(type: .all)
        self.broadcast(signal: servicesSignal, withAnswerToReceiver: servicesListController)
        return servicesListController
    }

    // Возвращает готовый контроллер создания подписки на определенный сервис
    private func getAddSubConfiguredController(service: ServiceProtocol?, transitionManager: UIViewControllerTransitioningDelegate?) -> UIViewController {
        let addSubController = ControllerFactory.getAddSubscriptionController()
        
        // Сервис, для которого создается подписка
        if service != nil {
            addSubController.service = service!
        }
        
        // Список валют
        let currenciesSignal = CurrencySignal.getCurrencies
        if let answer = self.broadcast(signalWithReturnAnswer: currenciesSignal).first as? CurrencySignal, case CurrencySignal.currencies(let currencies) = answer {
            addSubController.currencies = currencies
        }
        
        // Дефолтная фвалюта
        let defaultCurrencySignal = CurrencySignal.getDefaultCurrency
        if let answer = self.broadcast(signalWithReturnAnswer: defaultCurrencySignal).first as? CurrencySignal, case CurrencySignal.currency(let currency) = answer {
            addSubController.currentCurrency = currency
        }

        if let transition = transitionManager {
            addSubController.transitioningDelegate = transition
            addSubController.modalPresentationStyle = .custom
        }

        addSubController.onCancelScene = { inputData in
            self.disroute(controller: addSubController, method: .dismiss)
        }
        addSubController.onSaveSubscription = { [self] newSubscription, isNewService in
            self.disroute(controller: addSubController, method: .dismiss)

            // Уведомление
            let controller = ControllerFactory.getNotificationAlertController()
            controller.text = NSLocalizedString("sub created", comment: "")
            controller.image = UIImage(systemName: "checkmark.circle.fill")!
            let localTransitionManager = NotificationAlertTransitionManager()
            transitionManagers.append(localTransitionManager)
            self.route(from: presenter!, to: controller, method: .custom(localTransitionManager))
            
            //presenter!.present(controller, animated: true, completion: nil)

            // стирает введенные данные
            // чтобы новая подписка вводилась со стандартными данными
            //self.addedSubscriptionData = getDefaultSubscription(for: subscriptionForService)
            
            let signal = SubscriptionSignal.createUpdate(subscriptions: [newSubscription], broadcastActualSubscriptionsList: true)
            self.broadcast(signal: signal, withAnswerToReceiver: nil)
      
        }

        return addSubController
    }
}
