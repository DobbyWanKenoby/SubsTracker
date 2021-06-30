//
//  StatusBar.swift
//  SubscriptionsPlan
//
//  Created by Admin on 28.06.2021.
//

import UIKit

class StatusBar {
    static var instance: UIStatusBarManager {
        return (UIApplication.shared.connectedScenes.first as! UIWindowScene).statusBarManager!
    }
    static var frame: CGRect {
        return Self.instance.statusBarFrame
    }
}

class SafeArea {
    static var inset: UIEdgeInsets {
        return UIApplication.shared.windows.first!.safeAreaInsets
    }
}
