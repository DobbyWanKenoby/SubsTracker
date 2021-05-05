//
//  NewSubscription.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 04.05.2021.
//

import Foundation

protocol NewSubscriptionProtocol {
    var subscription: SubscriptionProtocol { get set }
}

struct NewSubscription: NewSubscriptionProtocol {
    var subscription: SubscriptionProtocol
}
