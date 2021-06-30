//
//  SubscriptionEntity+CoreDataClass.swift
//  SubscriptionsPlan
//
//  Created by Admin on 09.06.2021.
//
//

import Foundation
import CoreData

@objc(SubscriptionEntity)
public class SubscriptionEntity: NSManagedObject, EntityInstanceProvider {
    
    typealias AssociatedInstanceType = SubscriptionProtocol
    
    @discardableResult
    static func getEntity(from subscription: SubscriptionProtocol, context: NSManagedObjectContext, updateEntityPropertiesIfNeeded: Bool = false) -> Self {
        let fetch = NSFetchRequest<SubscriptionEntity>(entityName: "SubscriptionEntity")
        fetch.predicate = NSPredicate(format: "identifier = %@", subscription.identifier.uuidString)
        fetch.fetchBatchSize = 1
        guard let subscriptionsFromStorage = try? context.fetch(fetch),
              let subscriptionFromStorage = subscriptionsFromStorage.first else {
            let subscriptionEntity = SubscriptionEntity(context: context)
            subscriptionEntity.updateEntity(from: subscription, context: context)
            return subscriptionEntity as! Self
        }
        if updateEntityPropertiesIfNeeded {
            subscriptionFromStorage.updateEntity(from: subscription, context: context)
        }
        return subscriptionFromStorage as! Self
    }
    
    func updateEntity(from subscription: SubscriptionProtocol, context: NSManagedObjectContext) {
        self.identifier = subscription.identifier
        self.about = subscription.description
        self.currency = CurrencyEntity.getEntity(from: subscription.currency, context: context)
        self.service = ServiceEntity.getEntity(from: subscription.service, context: context)
        self.amount = subscription.amount
        self.isNotificationable = subscription.isNotificationable
        self.notificationDaysPeriod = Int16(subscription.notificationDaysPeriod)
        self.firstPaymentDate = subscription.firstPaymentDate
        self.paymentPeriodInt = Int16(subscription.paymentPeriod.0)
        self.paymentPeriodType = subscription.paymentPeriod.1.rawValue
    }
    
    func convertEntityToInstance() -> SubscriptionProtocol {
        Subscription(identifier: self.identifier!,
                        service: self.service!.convertEntityToInstance(),
                        amount: self.amount,
                        currency: self.currency!.convertEntityToInstance(),
                        description: self.about!,
                        firstPaymentDate: self.firstPaymentDate!,
                        paymentPeriod: (Int(self.paymentPeriodInt), PeriodType.init(rawValue: self.paymentPeriodType!)!),
                        isNotificationable: self.isNotificationable,
                        notificationDaysPeriod: Int(self.notificationDaysPeriod))
    }
    
}
