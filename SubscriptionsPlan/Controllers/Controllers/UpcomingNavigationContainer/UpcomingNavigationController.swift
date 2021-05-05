//
//  UpcomingNavigationController.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 03.01.2021.
//

import UIKit

class UpcomingNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem = getBarIcon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func getBarIcon() -> UITabBarItem {
        let symbolConfigaration = UIImage.SymbolConfiguration(weight: .heavy)
        let icon = UIImage(systemName: "line.horizontal.3", withConfiguration: symbolConfigaration)
        let iconTabBarItem = UITabBarItem(title: "Ближайшие", image: icon, tag: 0)
        return iconTabBarItem
    }
 
}
