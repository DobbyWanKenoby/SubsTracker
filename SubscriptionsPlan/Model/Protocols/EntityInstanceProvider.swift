//
//  EntityInstanceProvider.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 09.06.2021.
//

import Foundation
import CoreData

protocol EntityInstanceProvider {
    /// связанный с данным Entity тип модели
    associatedtype AssociatedInstanceType
    /// вовзращает Entity, соответсвующий переданному from
    /// создает новый Entity или получает существующий из базы
    @discardableResult
    static func getEntity(from: AssociatedInstanceType, context: NSManagedObjectContext, updateEntityPropertiesIfNeeded: Bool) -> Self
    /// обновить все свойства Entity в соответствии с Instances
    func updateEntity(from: AssociatedInstanceType)
    /// преобразовать Entity в Instance
    func convertEntityToInstance() -> AssociatedInstanceType
}
