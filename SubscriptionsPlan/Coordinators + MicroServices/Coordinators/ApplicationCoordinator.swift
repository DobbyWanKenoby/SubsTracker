//
//  AppCoordinator.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 03.01.2021.
//

import UIKit
import SwiftCoordinatorsKit

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
        CoordinatorFactory.getSettingMicroService(rootCoordinator: self, options: [.shared])
        // МикроСервис для работы с CoreData
        CoordinatorFactory.getCoreDataMicroService(rootCoordinator: self, options: [.shared])
        // МикроСервис для работы с сущностью Currency
        CoordinatorFactory.getCurrencyMicroService(rootCoordinator: self, options: [.shared])
        // МикроСервис для работы с сущностью Service
        CoordinatorFactory.getServiceMicroService(rootCoordinator: self, options: [.shared])
        // МикроСервис для работы с сущностью Payment
        let paymentCoordinator = CoordinatorFactory.getPaymentMicroService(rootCoordinator: self, options: [.shared])
        // МикроСервис для работы с сущностью Subscription
        // !!! родительским для SubCoord является PayCoord
        //  это сделано для того, чтобы при создании подписки
        //  автоматически проверялась дата следующего платежа
        //  и при необходимости подменялась и создавались записи о прошедших платежах
        CoordinatorFactory.getSubscriptionMicroService(rootCoordinator: paymentCoordinator, options: [.shared])
        
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

    }
}
