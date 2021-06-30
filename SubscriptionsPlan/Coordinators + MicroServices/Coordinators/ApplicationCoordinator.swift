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

    override func startFlow(finishCompletion: (() -> Void)? = nil) {
        super.startFlow(finishCompletion: finishCompletion)
        
        // Подключение Приемников (МикроСервисов)
        
        // МикроСервис с настройками приложения
        // Настройки пользователя + Системные настройки
        CoordinatorFactory.getSettingCoordinator(rootCoordinator: self)
        // МикроСервис для работы с CoreData
        CoordinatorFactory.getCoreDataMicroService(rootCoordinator: self)
        // МикроСервис для работы с сущностью Currency
        CoordinatorFactory.getCurrencyStorageMicroService(rootCoordinator: self)
        // МикроСервис для работы с сущностью Service
        CoordinatorFactory.getServiceStorageMicroService(rootCoordinator: self)
        // МикроСервис для работы с сущностью Subscription
        CoordinatorFactory.getSubscriptionStorageMicroService(rootCoordinator: self)
        
        // Запускаем координатор Инициализации
        let initializator = CoordinatorFactory.getInitializatorCoordinator(rootCoordinator: self)
        self.presenter = initializator.presenter
        initializator.startFlow {
            
            // По окончании работы координатора инициализации
            // должен отобразиться интерфейс приложения
            let functionalCoordinator = CoordinatorFactory.getIFunctionalCoordinator(rootCoordinator: self)
            functionalCoordinator.startFlow()
            self.route(from: self.presenter!, to: functionalCoordinator.presenter!, method: .presentCard) {
                self.presenter?.view.removeFromSuperview()
                self.presenter = nil
            }
                      
        }
        
        // Микросервис-Синглтон для доступа к важным базовым настройкам
        //Settings.shared = Settings(rootCoordinator: self)

    }
}
