//
//  AppCoordinator.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 03.01.2021.
//

import UIKit

final class ApplicationCoordinator: BaseCoordinator {

    // координатор ориентирован на работу с TabBar
    // поэтому сделаем вспомогательное свойства
    private var tabBarPresenter: UITabBarController? {
        return presenter as? UITabBarController
    }

    override func startFlow() {

//        // Upcoming
//        let upcomingCoordinator = CoordinatorFactory.getCoordinator(type: .Upcoming)
//        childCoordinators.append(upcomingCoordinator)
//        upcomingCoordinator.rootCoordinator = self
//        upcomingCoordinator.start()
//
        // Flow Создания подписки на сервисы
        let addSubsCoordinator = CoordinatorFactory.getAddSubscriptionCoordinator(rootCoordinator: self)
        childCoordinators.append(addSubsCoordinator)
        addSubsCoordinator.startFlow()

        tabBarPresenter?.viewControllers = [
            addSubsCoordinator.presenter ?? UIViewController(),
        ]
    }
}

extension ApplicationCoordinator: Transmitter {
    func useInThisTransmitter(data: TransmittedData) {
        //print("Use transmitted data \(data) in AppCoordinator")
    }
}

