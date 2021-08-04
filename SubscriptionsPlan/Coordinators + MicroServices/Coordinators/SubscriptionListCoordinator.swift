import UIKit
import SwiftCoordinatorsKit

protocol SubscriptionListCoordinatorProtocol: BasePresenter, Transmitter, Receiver {}

class SubscriptionListCoordinator: BasePresenter, SubscriptionListCoordinatorProtocol {
    var edit: ((Signal) -> Signal)?
    
    var listController: SubscriptionsListControllerProtocol!
    // strong ссылки на менеджеры перехода
    var transitionManagers: [UIViewControllerTransitioningDelegate] = []
    
    private var navigationPresenter: UINavigationController? {
        return presenter as? UINavigationController
    }
    
    override func startFlow(withWork work: (() -> Void)? = nil, finishCompletion: (() -> Void)? = nil) {
        super.startFlow(withWork: work, finishCompletion: finishCompletion)
        navigationPresenter?.navigationBar.prefersLargeTitles = true
        
        // Контроллер со списком подписок
        listController = loadSubscriptionsListController()
        childControllers.append(listController)
        listController.subscriptions = getSubscriptions()
        
        self.route(from: navigationPresenter!, to: listController, method: .navigationPush)
    }
    
    private func loadSubscriptionsListController() -> SubscriptionsListControllerProtocol {
        let controller = ControllerFactory.getSubscriptionsListController()
        controller.onActivateEditSubscription = { subscription in
            let nextController = self.getEditSubscriptionConfiguredController(subscription: subscription)
            self.route(from: self.presenter!, to: nextController, method: .presentCard)
        }
        controller.onSuccessNextPayment = { subscription in
            var dateComponents = DateComponents()
            dateComponents.day = 1
            let nextDayAfterPayment = Calendar.current.date(byAdding: dateComponents, to: subscription.nextPaymentDate) ?? Date()
            let alert = UIAlertController(title: NSLocalizedString("success payment", comment: ""),
                                          message: String(format: NSLocalizedString("do payment now %@", comment: ""), subscription.service.title) + " \(getDateLocaleFormat(nextDayAfterPayment))",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: { _ in
                // отправляем запрос на создание платежей
                let signalNewPayments = PaymentSignal.createPayments(count: 1, forSubscription: subscription, editSubscription: true)
                self.broadcast(signal: signalNewPayments, withAnswerToReceiver: nil)
                // просим разослать актуальный список подписок по всей структуре приложения
                let signalActualSubs = SubscriptionSignal.getActualSubscriptions(broadcastActualSubscriptionsList: true)
                self.broadcast(signal: signalActualSubs, withAnswerToReceiver: nil)
            })
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
                return
            })
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.route(from: self.presenter!, to: alert, method: .presentCard)
        }
        return controller
    }
    
    // Возвращает готовый контроллер редактирования существующей подписки
    private func getEditSubscriptionConfiguredController(subscription: SubscriptionProtocol) -> UIViewController {
        let addSubController = ControllerFactory.getAddSubscriptionController()
        addSubController.displayType = .editSubscription
        
        // редактируема подписка
        addSubController.subscription = subscription
        // подписка
        addSubController.service = subscription.service
        
        // Список валют
        let currenciesSignal = CurrencySignal.getCurrencies
        if let answer = self.broadcast(signalWithReturnAnswer: currenciesSignal).first as? CurrencySignal, case CurrencySignal.currencies(let currencies) = answer {
            addSubController.currencies = currencies
        }
        
        // Дефолтная валюта
        addSubController.currentCurrency = subscription.currency
        addSubController.onCancelScene = { inputData in
            self.disroute(controller: self.presenter!, method: .dismiss)
        }
        addSubController.onSaveSubscription = { [self] newSubscription, _ in
            self.disroute(controller: self.presenter!, method: .dismiss)

            // Уведомление
            let notificationController = ControllerFactory.getNotificationAlertController()
            notificationController.text = NSLocalizedString("sub updated", comment: "")
            notificationController.image = UIImage(systemName: "checkmark.circle.fill")!
            let notificationTransitionManager = NotificationAlertTransitionManager()
            transitionManagers.append(notificationTransitionManager)
            self.route(from: presenter!, to: notificationController, method: .custom(notificationTransitionManager))

            
            let signal = SubscriptionSignal.createUpdate(subscriptions: [newSubscription], broadcastActualSubscriptionsList: true)
            self.broadcast(signal: signal, withAnswerToReceiver: nil)
      
        }
        return addSubController
    }
    
    // загрузка подписок
    private func getSubscriptions() -> [SubscriptionProtocol] {
        let signal = SubscriptionSignal.getAll
        guard let signalAnswer = self.broadcast(signalWithReturnAnswer: signal).first,
              case SubscriptionSignal.subscriptions(let subscriptions) = signalAnswer else {
            return []
        }
        return subscriptions
    }
    
    // MARK: - Receiver
    func receive(signal: Signal) -> Signal? {
        switch signal {
        case SubscriptionSignal.actualSubscriptions(let subscriptions):
            listController.subscriptions = subscriptions
        default:
            break
        }
        return nil
    }
}
