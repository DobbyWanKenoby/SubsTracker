// Сервис, обеспечивающий работу с сущностью "Сервис"

import Foundation
import CoreData
import SwiftCoordinatorsKit

protocol SubscriptionCoordinatorProtocol: BaseCoordinator, Transmitter, Receiver {}

class SubscriptionCoordinator: BaseCoordinator, SubscriptionCoordinatorProtocol {
    var edit: ((Signal) -> Signal)?
    
    // MARK: - CoreData
    
    lazy var context: NSManagedObjectContext = {
        let signalAnswer = broadcast(signalWithReturnAnswer: CoreDataSignal.getDefaultContext).first as! CoreDataSignal
        if case CoreDataSignal.context(let context) = signalAnswer {
            return context
        } else {
            fatalError("Can't get a Core Data context in Subscription Coordinator")
        }
    }()
    
    func savePersistance() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error during saving context in SubscriptionCoordinator. Error message: \(error)")
            }
        }
    }
    
    // MARK: - Receiver
    
    func receive(signal: Signal) -> Signal? {

        switch signal {
        
        // создание/обновление Подписки
        case SubscriptionSignal.createUpdate(let subscriptions, let needBroadcastSubscriptions):
            subscriptions.forEach{ subscription in
                createUpdate(from: subscription)
                if Calendar.current.compare(Date(), to: subscription.nextPaymentDate, toGranularity: .day) == .orderedDescending {
                    let signal = SubscriptionSignal.checkSubscriptionsOnPayments([subscription])
                    self.broadcast(signal: signal, withAnswerToReceiver: nil)
                }
            }
            
            if needBroadcastSubscriptions {
                let subscriptions = getActualSubscriptions()
                let signal = SubscriptionSignal.actualSubscriptions(subscriptions)
                self.broadcast(signal: signal, withAnswerToReceiver: nil)
            }
            
        // Удаление подписок
        case SubscriptionSignal.removeSubscription(id: let removingSubID, removePayments: let doRemovePayments):
            if doRemovePayments {
                let signal = PaymentSignal.removePayments(forSubscriptionID: removingSubID)
                self.broadcast(signal: signal, withAnswerToReceiver: nil)
            }
            removeSubscription(withID: removingSubID)
            break
            
        // Получение всех подписок
//        case SubscriptionSignal.getAll:
//            let signal = SubscriptionSignal.subscriptions(getActualSubscriptions())
//            return signal
        
        // Получение актуальных подписок
        case SubscriptionSignal.getActualSubscriptions(broadcastActualSubscriptionsList: let needBroadcastSubscriptions):
            let subscriptions = getActualSubscriptions()
            let signal = SubscriptionSignal.actualSubscriptions(subscriptions)
            if needBroadcastSubscriptions {
                self.broadcast(signal: signal, withAnswerToReceiver: nil)
            }
            return signal
        default:
            break
        }
        
        return nil
    }
    
    private func createUpdate(from currency: SubscriptionProtocol) {
        SubscriptionEntity.getEntity(from: currency, context: context, updateEntityPropertiesIfNeeded: true)
        savePersistance()
    }
    
    // удаление определенной подписки
    private func removeSubscription(withID id: UUID) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SubscriptionEntity")
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", id.uuidString)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            self.savePersistance()
        } catch {
            fatalError("Error message: \(error)")
        }
    }
    
    // получение списка актуальных Подписок
    private func getActualSubscriptions() -> [SubscriptionProtocol] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SubscriptionEntity")

        do {
            let entities = try context.fetch(fetchRequest)
            var resultArray = [Subscription]()
            for entity in entities {
                guard let instance = (entity as? SubscriptionEntity)?.convertEntityToInstance() as? Subscription else {
                    continue
                }
                resultArray.append(instance)
            }
            return resultArray
        } catch {
            fatalError("Error during load Subscriptions by identifier. Error message: \(error)")
        }
    }

}
