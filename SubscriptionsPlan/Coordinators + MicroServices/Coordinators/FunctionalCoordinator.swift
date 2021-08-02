//
//  FunctionalCoordinator.swift
//  SubscriptionsPlan
//
//  Created by Admin on 18.06.2021.
//

import UIKit
import SwiftCoordinatorsKit

protocol FunctionalCoordinatorProtocol: BasePresenter, Transmitter {}

class FunctionalCoordinator: BasePresenter, FunctionalCoordinatorProtocol {

    private var tabBarPresenter: UITabBarController {
        presenter as! UITabBarController
    }
    
    override func startFlow(finishCompletion: (() -> Void)? = nil) {
        super.startFlow(finishCompletion: finishCompletion)
        setupPresenter()
        startChildCoordinators()
    }
    
    private func setupPresenter() {
        tabBarPresenter.modalPresentationStyle = .fullScreen
    }
    
    private func startChildCoordinators() {
        // создаем вложенный координатор создания подписки
        let addSubsCoordinator = CoordinatorFactory.getAddSubscriptionCoordinator(rootCoordinator: self)
        addSubsCoordinator.startFlow()
        
        let subscriptionListCoordinator = CoordinatorFactory.getSubscriptionListCoordinator(rootCoordinator: self)
        subscriptionListCoordinator.startFlow()

        tabBarPresenter.viewControllers = [
            addSubsCoordinator.presenter ?? UIViewController(),
            subscriptionListCoordinator.presenter ?? UIViewController()
        ]
        tabBarPresenter.selectedIndex = 1
    }
    
}
