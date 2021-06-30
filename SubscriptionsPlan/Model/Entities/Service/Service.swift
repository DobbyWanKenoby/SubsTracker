//
//  Service.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 31.12.2020.
//

import UIKit

// MARK: - Сервис, на который можно подписаться

protocol ServiceProtocol {
    // уникальный идентификатор
    var identifier: String { get }
    // заголовок
    var title: String { get }
    // логотип-картинка
    var logo: UIImage { get }
    // название файла логотипа
    var logoFileName: String { get }
    // цвет
    var color: UIColor { get }
    // цвет в HEX-формате
    var colorHEX: String { get }
    // флаг "кастомный сервис"
    // если создается кастомный сервис, то данное свойство необходимо установить в true
    var isCustom: Bool { get set }

    init(identifier: String, title: String, colorHEX: String, customLogoImage: String?)
}

struct Service: ServiceProtocol {
    var identifier: String
    var title: String
    var logo: UIImage {
        guard let image = UIImage(named: "\(logoFileName.lowercased())") else {
            return UIImage()
        }
        return image
    }
    var logoFileName: String
    var color: UIColor {
        UIColor(hex: colorHEX)!
    }
    var colorHEX: String
    var isCustom: Bool = false
    
    init(identifier: String, title: String, colorHEX: String, customLogoImage: String? = nil) {
        self.identifier = identifier
        self.title = title
        self.colorHEX = colorHEX
        if customLogoImage != nil {
            logoFileName = customLogoImage!
        } else {
            logoFileName = identifier
        }
    }
    
    
}
