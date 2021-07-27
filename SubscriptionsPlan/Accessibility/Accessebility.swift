//
//  Accessebility.swift
//  SubscriptionsPlan
//
//  Created by Admin on 27.07.2021.
//

import UIKit
import Foundation

enum Accessibility: String {
    case doneButton
    case newSubscriptionTab
    
    func getLocalizationAccesebility() -> String {
        return NSLocalizedString("\(Self.self) \(self.rawValue)", comment: "")
    }
}

func setAccesebility(for view: UIView, with: Accessibility) {
    view.accessibilityIdentifier = with.rawValue
    view.accessibilityLabel = with.getLocalizationAccesebility()
}
