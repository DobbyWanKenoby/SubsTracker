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
        
        // МикроСервис для работы с сущностью Service
        let _ = ServiceStorageCoordinator(rootCoordinator: self)

//        // Upcoming
//        let upcomingCoordinator = CoordinatorFactory.getCoordinator(type: .Upcoming)
//        childCoordinators.append(upcomingCoordinator)
//        upcomingCoordinator.rootCoordinator = self
//        upcomingCoordinator.start()
//
        // Flow Создания подписки на сервисы
        let addSubsCoordinator = CoordinatorFactory.getAddSubscriptionCoordinator(rootCoordinator: self)
        addSubsCoordinator.startFlow()
        
        tabBarPresenter?.viewControllers = [
            addSubsCoordinator.presenter ?? UIViewController(),
        ]
    }
}
