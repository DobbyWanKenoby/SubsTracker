// Сервис, обеспечивающий работу с сущностью "Сервис"

import Foundation
import CoreData
import SwiftCoordinatorsKit

protocol SubscriptionCoordinatorProtocol: BaseCoordinator, Transmitter, Receiver {}

class SubscriptionCoordinator: BaseCoordinator, SubscriptionCoordinatorProtocol {
    
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
                fatalError("Error during saving Currencies to Storage. Error message: \(error)")
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
            }
            if needBroadcastSubscriptions {
                let subscriptions = getActualSubscriptions()
                let signal = SubscriptionSignal.actualSubscriptions(subscriptions)
                self.broadcast(signal: signal, withAnswerToReceiver: nil)
            }
            
        case SubscriptionSignal.getAll:
            let signal = SubscriptionSignal.subscriptions(getActualSubscriptions())
            return signal
            
        case SubscriptionSignal.getActualSubscriptions(broadcastActualSubscriptionsList: let needBroadcastSubscriptions):
            let subscriptions = getActualSubscriptions()
            if needBroadcastSubscriptions {
                let signal = SubscriptionSignal.actualSubscriptions(subscriptions)
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
