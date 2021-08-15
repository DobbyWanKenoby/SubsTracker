import UIKit
import SwiftCoordinatorsKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var coordinator: AppCoordinator!

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        coordinator = CoordinatorFactory.getAppCoordinator()
        coordinator.startFlow(withWork: {
            // Подключение Приемников (МикроСервисов)
            
            // МикроСервис с настройками приложения
            // Настройки пользователя + Системные настройки
            CoordinatorFactory.getSettingMicroService(rootCoordinator: self.coordinator, options: [.shared])
            // МикроСервис для работы с CoreData
            CoordinatorFactory.getCoreDataMicroService(rootCoordinator: self.coordinator, options: [.shared])
            // МикроСервис для работы с сущностью Currency
            CoordinatorFactory.getCurrencyMicroService(rootCoordinator: self.coordinator, options: [.shared])
            // МикроСервис для работы с сущностью Service
            CoordinatorFactory.getServiceMicroService(rootCoordinator: self.coordinator, options: [.shared])
            // МикроСервис для работы с сущностью Payment
            let paymentCoordinator = CoordinatorFactory.getPaymentMicroService(rootCoordinator: self.coordinator, options: [.shared])
            // МикроСервис для работы с сущностью Subscription
            // !!! Родительским для SubCoord является PayCoord
            //  это сделано для того, чтобы при создании подписки
            //  автоматически проверялась дата следующего платежа
            //  и при необходимости подменялась и создавались записи о прошедших платежах
            CoordinatorFactory.getSubscriptionMicroService(rootCoordinator: paymentCoordinator, options: [.shared])
        }, finishCompletion: nil)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

