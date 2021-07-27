//
//  AddSubscriptionNavigationController.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 03.01.2021.
//

import UIKit

protocol AddSubscriptionBaseControllerProtocol where Self: UIViewController {}

class AddSubscriptionNavigationController: UINavigationController, AddSubscriptionBaseControllerProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem = getBarIcon()
    }

    private func getBarIcon() -> UITabBarItem {
        let symbolConfigaration = UIImage.SymbolConfiguration(weight: .heavy)
        let icon = UIImage(systemName: "plus.square.fill", withConfiguration: symbolConfigaration)
        let iconTabBarItem = UITabBarItem(title: NSLocalizedString("new_subscription", comment: ""), image: icon, tag: 0)
        setAccessibilities(iconTabBarItem, with: .newSubscriptionTab)
        return iconTabBarItem
    }
}
