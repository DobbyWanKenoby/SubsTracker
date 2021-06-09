import UIKit

protocol SubscriptionsBaseControllerProtocol where Self: UINavigationController{}

class SubscriptionsNavigationController: UINavigationController, SubscriptionsBaseControllerProtocol {

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
        let iconTabBarItem = UITabBarItem(title: "Подписки", image: icon, tag: 0)
        return iconTabBarItem
    }
 
}
