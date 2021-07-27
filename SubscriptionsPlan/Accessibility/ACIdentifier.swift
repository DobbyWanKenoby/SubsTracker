//
//  Accessebility.swift
//  SubscriptionsPlan
//
//  Created by Admin on 27.07.2021.
//

import UIKit
import Foundation

public enum ACIdentifier: String {
    
    // Кнопка готово
    // Обычно используется над клавиатурой
    case doneButton
    
    // Главный табБар
    // вкладка Новая подписка
    case newSubscriptionTab
    
    // Экран созданяи подписки
    // ячейка со стоимостью
    case cellAmount
    // ячейка с типом валюты
    case cellCurrency
    
    func getLocalizationAccesibility() -> String {
        return NSLocalizedString("Accessibility \(self.rawValue)", comment: "")
    }
}

func setAccessibilities( _ element: UIAccessibilityIdentification & NSObject, with accessibilityValue: ACIdentifier ) {
    element.accessibilityIdentifier = accessibilityValue.rawValue
    element.accessibilityLabel = accessibilityValue.getLocalizationAccesibility()
}
