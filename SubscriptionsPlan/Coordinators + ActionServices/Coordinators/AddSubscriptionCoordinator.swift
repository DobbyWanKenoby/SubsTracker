//
//  UpcomingCoordinator.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 03.01.2021.
//

import UIKit

protocol AddSubscriptionCoordinatorProtocol: BasePresenter, Transmitter {}

class AddSubscriptionCoordinator: BasePresenter, AddSubscriptionCoordinatorProtocol {
    
    private var navigationPresenter: UINavigationController? {
        return presenter as? UINavigationController
    }
    
    // strong ссылки на менеджеры перехода
    var transitionManagers: [UIViewControllerTransitioningDelegate] = []
    
    // используется для сохранения данных
    // если пользователь ввел данные в окне создания подписки
    // и случайно или специально его закрыл
    var addedSubscriptionData: SubscriptionProtocol?
    
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
            let transitionManager = AddSubsTransitionManager()
            transitionManager.startGlobalPoint = globalPoint
            transitionManager.startLocalPoint = selectedCell.frame.origin
            transitionManager.startSize = selectedCell.frame.size
            transitionManager.cellView = selectedCell
            transitionManager.cellRootView = selectedCell.superview
            self.transitionManagers.append(transitionManager)
            // контроллер, к которому будет происходить переход
            let nextController = getAddSubConfiguredController(service: service, transitionManager: transitionManager)
            presenter!.present(nextController, animated: true, completion: nil)
        }
        
        // Загрузка сервисов
        // обрабатываются полученные сервисы в методе receive контроллера со списком сервисов
        let serviceRequest = ServiceSignal.load(type: .all)
        self.broadcast(signal: serviceRequest, answerReceiver: servicesListController)
        
        return servicesListController
    }

    // Возвращает готовый контроллер создания подписки на определенный сервис
    private func getAddSubConfiguredController(service: ServiceProtocol?, transitionManager: UIViewControllerTransitioningDelegate?) -> UIViewController {
        let addSubController = ControllerFactory.getAddSubscriptionController()
        
        var subscriptionForService: ServiceProtocol
        if service == nil {
            addSubController.isNewService = true
            subscriptionForService = Service(identifier: "own", title: "Новый сервис", logo: nil, color: .gray)
        } else {
            addSubController.isNewService = false
            subscriptionForService = service!
        }
        
        if self.addedSubscriptionData == nil {
            self.addedSubscriptionData = getDefaultSubscription(for: subscriptionForService)
        } else {
            self.addedSubscriptionData!.service = subscriptionForService
        }

        addSubController.subscription = addedSubscriptionData!
        
        
        // загружаем валюты и передаем в контроллер для отображения
//        let currenciesLoadAction = CurrencyAction.load
//        addSubController.currencies = (self.broadcast(data: [currenciesLoadAction], sourceCoordinator: self).first as! [CurrencyProtocol])

        if let transition = transitionManager {
            addSubController.transitioningDelegate = transition
            addSubController.modalPresentationStyle = .custom
        }

        addSubController.onCancelScene = { inputData in
            addSubController.dismiss(animated: true, completion: nil)
            // используется для сохранения введенных данных
            // чтобы они вновь отображались после скрытия/открытия экрана создания подписки
            self.addedSubscriptionData = inputData
        }

        addSubController.onSaveSubscription = { [self] newSubscription in
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

            // стирает введенные данные
            // чтобы новая подписка вводилась со стандартными данными
            self.addedSubscriptionData = getDefaultSubscription(for: subscriptionForService)
            
//            let actionSubscription = SubscriptionAction.new(subscription: newSubscription)
//            let _ = broadcast(data: [actionSubscription], sourceCoordinator: self)
      
        }

        return addSubController
    }
}
