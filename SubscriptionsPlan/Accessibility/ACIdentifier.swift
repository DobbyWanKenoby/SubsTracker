//
//  Accessebility.swift
//  SubscriptionsPlan
//
//  Created by Admin on 27.07.2021.
//

import UIKit
import Foundation

public enum ACIdentifier: String {
    case doneButton
    case newSubscriptionTab
    
    func getLocalizationAccesebility() -> String {
        return NSLocalizedString("\(Self.self) \(self.rawValue)", comment: "")
    }
}
