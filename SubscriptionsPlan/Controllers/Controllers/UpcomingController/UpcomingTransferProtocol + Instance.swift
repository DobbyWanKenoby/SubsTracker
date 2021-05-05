import UIKit

protocol UpcomingTransferInterface where Self: UIViewController {
    /// Входные данные
    var inputData: UpcomingControllerInputDataElements! { get set }
    /// Выходные коллбеки
}

struct UpcomingControllerInputDataElements {
    var subscriptions: [SubscriptionProtocol]
}
