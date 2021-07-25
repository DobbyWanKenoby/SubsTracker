//
//  PaymentEntity+CoreDataClass.swift
//  PaymentsPlan
//
//  Created by Admin on 08.07.2021.
//

import Foundation
import CoreData

@objc(PaymentEntity)
public class PaymentEntity: NSManagedObject, EntityInstanceProvider {
    
    typealias AssociatedInstanceType = PaymentProtocol
    
    @discardableResult
    static func getEntity(from payment: PaymentProtocol, context: NSManagedObjectContext, updateEntityPropertiesIfNeeded: Bool = false) -> Self {
        let fetch = NSFetchRequest<PaymentEntity>(entityName: "PaymentEntity")
        fetch.predicate = NSPredicate(format: "identifier = %@", payment.identifier.uuidString)
        fetch.fetchBatchSize = 1
        guard let paymentsFromStorage = try? context.fetch(fetch),
              let paymentFromStorage = paymentsFromStorage.first else {
            let paymentEntity = PaymentEntity(context: context)
            paymentEntity.updateEntity(from: payment, context: context)
            return paymentEntity as! Self
        }
        if updateEntityPropertiesIfNeeded {
            paymentFromStorage.updateEntity(from: payment, context: context)
        }
        return paymentFromStorage as! Self
    }
    
    func updateEntity(from payment: PaymentProtocol, context: NSManagedObjectContext) {
        self.identifier = payment.identifier.uuidString
        self.amount = payment.amount
        self.currency = CurrencyEntity.getEntity(from: payment.currency, context: context)
        self.date = payment.date
        self.service = ServiceEntity.getEntity(from: payment.service, context: context)
        guard let subscription = SubscriptionEntity.getEntity(byIdentifier: payment.subscriptionIdentifier, context: context) else {
            return
        }
        self.subscription = subscription
    }
    
    func convertEntityToInstance() -> PaymentProtocol {
        Payment(identifier: UUID(uuidString: self.identifier!) ?? UUID(),
                forSubscription: self.subscription!.convertEntityToInstance(),
                date: self.date!,
                currency: self.currency!.convertEntityToInstance(),
                amount: self.amount)
    }
    
}
