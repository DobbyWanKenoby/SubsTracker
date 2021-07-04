//
//  TextField.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 30.06.2021.
//

import UIKit

enum ResponderStandardEditActions: CaseIterable {
    case cut, copy, paste, select, selectAll, delete
    
    var selector: Selector {
        switch self {
            case .cut:
                return #selector(UIResponderStandardEditActions.cut)
            case .copy:
                return #selector(UIResponderStandardEditActions.copy)
            case .paste:
                return #selector(UIResponderStandardEditActions.paste)
            case .select:
                return #selector(UIResponderStandardEditActions.select)
            case .selectAll:
                return #selector(UIResponderStandardEditActions.selectAll)
            case .delete:
                return #selector(UIResponderStandardEditActions.delete)
        }
    }
}

class TextField: UITextField {
    
    var actions: [ResponderStandardEditActions] = [.copy, .cut, .delete, .paste, .select, .selectAll]
    
    func disableAllActions() {
        actions = []
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        for actionElement in actions {
            if action == actionElement.selector {
                return true
            }
        }
        return false
    }
}
