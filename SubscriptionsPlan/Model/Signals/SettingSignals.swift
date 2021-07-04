//
//  SettingSignals.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 30.06.2021.
//

import Foundation

enum SettingSignal: Signal {
    // -----
    // Версия приложения при которой проводилась полная инициализация
    // Используется для того, чтобы проводить инициализацию сервисов и валют только при обновлении версии
    // -> lastInitializationAppVersion
    case getLastInitializationAppVersion
    // передача версии
    case lastInitializationAppVersion(String)
    // обновление версии
    case updateLastInitializationAppVersion(String)
}
