import UIKit

protocol AddSubscriptionProtocol where Self: UIViewController {
    // Input Data
    var subscription: AddSubscriptionElement! { get set }
    // Output Callbacks
    var onCancelScene: ((AddSubscriptionElement?) -> Void)? { get set }
    var onSaveSubscription: ((AddSubscriptionElement) -> Void)? { get set }
}

struct AddSubscriptionElement {
    var service: ServiceProtocol
    var isCustomService: Bool
    var editingSubscriptionIdentifier: Int?
    var amount: Float
    var currency: CurrencyProtocol
    var date: Date
    var paymentPeriod: (Int, PeriodType)
    var notice: String
    var isNotificationable: Bool
    var notificationDaysPeriod: Int 
}

func getDefaultAddSubControllerInputData(for service: ServiceProtocol) -> AddSubscriptionElement {
    return AddSubscriptionElement(
        service: service,
        isCustomService: false,
        editingSubscriptionIdentifier: nil,
        amount: 0,
        currency: Settings.shared.defaultCurrency,
        date: Date(),
        paymentPeriod: (5,.week),
        notice: "",
        isNotificationable: true,
        notificationDaysPeriod: 1)
}
