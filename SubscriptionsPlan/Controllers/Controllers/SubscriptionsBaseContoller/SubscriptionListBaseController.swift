import UIKit

protocol SubscriptionsBaseControllerProtocol where Self: UINavigationController{}

class SubscriptionListBaseController: UINavigationController, SubscriptionsBaseControllerProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem = getBarIcon()
    }
    
    private func getBarIcon() -> UITabBarItem {
        let symbolConfigaration = UIImage.SymbolConfiguration(weight: .heavy)
        let icon = UIImage(systemName: "line.horizontal.3", withConfiguration: symbolConfigaration)
        let iconTabBarItem = UITabBarItem(title: NSLocalizedString("subscriptions", comment: ""), image: icon, tag: 0)
        return iconTabBarItem
    }
 
}
