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
        
        // МикроСервис для работы с сущностью Currency
        CoordinatorFactory.getCurrencyStorageActionService(rootCoordinator: self)
        // МикроСервис для работы с сущностью Service
        CoordinatorFactory.getServiceStorageActionService(rootCoordinator: self)
        // МикроСервис для работы с сущностью Subscription
//        CoordinatorFactory.getSubscriptionStorageActionService(rootCoordinator: self)
        
        let initializator = CoordinatorFactory.getInitializatorCoordinator(rootCoordinator: self)
        self.presenter = initializator.presenter
        initializator.startFlow {
            
            // по окончании flow инициализации
            // необходимо начать flow основной программы
            
            // сперва создаем tabBarController
            // он будет основным для приложения после отработки контроллера инициализации
            let barController = ControllerFactory.getDefaultController(byType: .tabBar) as! UITabBarController
            barController.modalPresentationStyle = .fullScreen
            
            // создаем вложенный координатор создания подписки
            let addSubsCoordinator = CoordinatorFactory.getAddSubscriptionCoordinator(rootCoordinator: self)
            addSubsCoordinator.startFlow()
            
            barController.viewControllers = [
                addSubsCoordinator.presenter ?? UIViewController(),
                //subscriptionsCoordinator.presenter ?? UIViewController(),
            ]
            
            self.presenter?.present(barController, animated: true, completion: {
                self.presenter?.view.removeFromSuperview()
                self.presenter = nil
                // все еще остается ссылка на InitializatorController в Window
                // но она настолько несущественна, что удалять ее не будем
            })
            
            
            
        }
        
        
        
        // Микросервис-Синглтон для доступа к важным базовым настройкам
        //Settings.shared = Settings(rootCoordinator: self)

        
        
        // Подключение координаторов-презенторов и запуск их flow
        // они будут отображать собственные экраны

        // Flow Создания подписки на сервисы
//        let addSubsCoordinator = CoordinatorFactory.getAddSubscriptionCoordinator(rootCoordinator: self)
//        addSubsCoordinator.startFlow()
//
//        // Flow для отображения и редактирования созданных подписок
//        let subscriptionsCoordinator = CoordinatorFactory.getSubscriptionsCoordinator(rootCoordinator: self)
//        subscriptionsCoordinator.startFlow()
//

    }
    
    private func setupAddSubscriptionCoordinator() {
        
    }
}
