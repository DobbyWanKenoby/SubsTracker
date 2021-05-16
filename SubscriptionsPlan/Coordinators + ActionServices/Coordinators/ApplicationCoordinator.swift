//
//  AppCoordinator.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 03.01.2021.
//

import UIKit

protocol ApplicationCoordinatorProtocol: BasePresenter, Transmitter {}

final class ApplicationCoordinator: BasePresenter, ApplicationCoordinatorProtocol {
    
    // координатор ориентирован на работу с TabBar
    // поэтому сделаем вспомогательное свойства
    private var tabBarPresenter: UITabBarController? {
        return presenter as? UITabBarController
    }

    override func startFlow() {
        
        // Подключение Микросервисов
        
        // МикроСервис для работы с сущностью Currency
        let _ = CoordinatorFactory.getCurrencyStorageActionService(rootCoordinator: self)
        // МикроСервис для работы с сущностью Service
        let _ = CoordinatorFactory.getServiceStorageActionService(rootCoordinator: self)
        // МикроСервис для работы с сущностью Subscription
        let _ = CoordinatorFactory.getSubscriptionStorageActionService(rootCoordinator: self)
        
        // Микросервис-Синглтон для доступа к важным базовым настройкам
        Settings.shared = Settings(rootCoordinator: self)

        // Подключение координаторов-презенторов и запуск их flow
        // они будут отображать собственные экраны

        // Flow Создания подписки на сервисы
        let addSubsCoordinator = CoordinatorFactory.getAddSubscriptionCoordinator(rootCoordinator: self)
        addSubsCoordinator.startFlow()
        
        // Flow для отображения и редактирования созданных подписок
        let subscriptionsCoordinator = CoordinatorFactory.getSubscriptionsCoordinator(rootCoordinator: self)
        subscriptionsCoordinator.startFlow()
        
        tabBarPresenter?.viewControllers = [
            addSubsCoordinator.presenter ?? UIViewController(),
            subscriptionsCoordinator.presenter ?? UIViewController(),
        ]
    }
}
