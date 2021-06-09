//
//  Service.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 31.12.2020.
//

import UIKit

// MARK: - Сервис, на который можно подписаться

protocol ServiceProtocol {
    var identifier: String { get }
    var title: String { get }
    var logo: UIImage { get }
    var color: UIColor { get }
}

//struct Service: ServiceProtocol {
//    var identifier: String
//    var title: String
//    var logo: UIImage?
//    var color: UIColor
//}
