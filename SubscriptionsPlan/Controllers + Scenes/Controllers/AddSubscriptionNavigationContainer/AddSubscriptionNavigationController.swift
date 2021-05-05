//
//  AddSubscriptionNavigationController.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 03.01.2021.
//

import UIKit

protocol AddSubscriptionControllerProtocol where Self: UIViewController {}

class AddSubscriptionNavigationController: UINavigationController, AddSubscriptionControllerProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem = getBarIcon()
    }

    private func getBarIcon() -> UITabBarItem {
        let symbolConfigaration = UIImage.SymbolConfiguration(weight: .heavy)
        let icon = UIImage(systemName: "plus.square.fill", withConfiguration: symbolConfigaration)
        let iconTabBarItem = UITabBarItem(title: "Новая подписка", image: icon, tag: 0)
        return iconTabBarItem
    }
}
