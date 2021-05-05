//
//  Service.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 31.12.2020.
//

import UIKit

// MARK: - Сервис, на который можно подписаться

protocol ServiceProtocol {
    /// Уикальный идентификатор
    var identifier: String { get set }
    /// Название сервиса
    var title: String { get set }
    /// Логотип сервиса
    var logo: UIImage? { get set }
    /// Цвет сервиса (один цвет или градиент). Используется для оформления фона
    var color: UIColor { get set }
}

struct Service: ServiceProtocol {
    var identifier: String
    var title: String
    var logo: UIImage?
    var color: UIColor
}
