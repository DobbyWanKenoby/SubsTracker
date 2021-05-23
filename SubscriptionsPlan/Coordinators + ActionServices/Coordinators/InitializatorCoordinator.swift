//
//  InitializatorCoordinator.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 23.05.2021.
//

import Foundation

protocol InitializatorCoordinatorProtocol: BasePresenter {}

class InitializatorCoordinator: BasePresenter, InitializatorCoordinatorProtocol {
    override func startFlow(finishCompletion: (() -> Void)? = nil) {
        super.startFlow(finishCompletion: finishCompletion)
        (self.presenter as? InitializatorControllerProtocol)?.initializationDidEnd = {
            self.finishFlow()
        }
    }
}
