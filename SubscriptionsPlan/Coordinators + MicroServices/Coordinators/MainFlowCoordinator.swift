//
//  AppCoordinator.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 03.01.2021.
//

import UIKit
import SwiftCoordinatorsKit

protocol MainFlowCoordinatorProtocol: BasePresenter, Transmitter {}

final class MainFlowCoordinator: BasePresenter, MainFlowCoordinatorProtocol {
    var edit: ((Signal) -> Signal)?
    
    convenience init(rootCoordinator: Coordinator, options: [CoordinatorOption] = []) {
        self.init(presenter: nil, rootCoordinator: rootCoordinator, options: options)
    }
    
    override var presenter: UIViewController? {
        didSet {
            (rootCoordinator as? SceneCoordinator)?.presenter = presenter
        }
    }

    override func startFlow(withWork work: (() -> Void)? = nil, finishCompletion: (() -> Void)? = nil) {
        super.startFlow(withWork: work, finishCompletion: finishCompletion)
        
        // Запускаем координатор Инициализации
        let initializator = CoordinatorFactory.getInitializatorCoordinator(rootCoordinator: self)
        self.presenter = initializator.presenter
        initializator.startFlow(withWork: nil, finishCompletion: {
            // По окончании работы координатора инициализации
            // должен отобразиться интерфейс приложения
            let functionalCoordinator = CoordinatorFactory.getFunctionalCoordinator(rootCoordinator: self)
            
            self.route(from: self.presenter!, to: functionalCoordinator.presenter!, method: .presentFullScreen)
            functionalCoordinator.startFlow()
        })
    }
}
