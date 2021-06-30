//
//  SettingsCoordinator.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 30.06.2021.
//

import Foundation

protocol SettingCoordinatorProtocol: BaseCoordinator, Receiver {}

// MARK: - Receiver

class SettingCoordinator: BaseCoordinator, SettingCoordinatorProtocol {

    func receive(signal: Signal) -> Signal? {
        if case SettingSignal.getLastInitializationAppVersion = signal {
            return SettingSignal.lastInitializationAppVersion(self.lastInitializationAppVersion)
        } else if case SettingSignal.updateLastInitializationAppVersion(let version) = signal {
            lastInitializationAppVersion = version
        }
        return nil
    }
}

// MARK: - Receiver logic

extension SettingCoordinator {
    // Версия приложения, при которой проводилась последняя полгная инициализация
    var lastInitializationAppVersion: String {
        get {
            UserDefaults.standard.string(forKey: "lastInitializatonVersion") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastInitializatonVersion")
        }
    }
}
