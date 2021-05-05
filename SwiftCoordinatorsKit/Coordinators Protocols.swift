import UIKit

// MARK: - Coordinator
// Координаторы управляют работой приложения
// - создают и отображают экраны
// - передают данные между друг другом (см. Data Transmitter)
// - передают данные в зависимые экраны (см. Data Transmitter)

// Координаторы могут быть системными, без отображаемых данных
// Пример такого системного координатора - ApplicationCoordinator

protocol Coordinator: AnyObject {
    var rootCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    func startFlow()
    func finishFlow()
}

// MARK: - View Presenter
protocol Presenter where Self: Coordinator {
    var childControllers: [UIViewController] { get set }
    var presenter: UIViewController? { get set }
}

// MARK: - Data Transmitter
// Данные могут передаваться между кооординаторами с помощью координаторов-трансмиттеров

typealias TransmittedData = [Any]

/// Координатор-трансмиттер может передавать данные. Данные передаются родительскому координатору и дочерним координаторам
protocol Transmitter where Self: Coordinator{
    /// Передача данных во всех связанные координаторы и контроллеры
    /// - Parameters:
    ///   - data: передаваемые данные
    ///   - sourceCoordinator: координатор-источник
    func transmit(data : TransmittedData, sourceCoordinator: Coordinator) -> Void
    // использовать переданных данных
    // данные отправляются в дочерние контроллеры
    // и используются в самом трансмитере с помощью метода useInThisTransmitter
    func use(transmittedData data: TransmittedData) -> Void
    func useInThisTransmitter(data: TransmittedData) -> Void
}

extension Transmitter {
    
    /// Передача данных в зависимые координаторы и их использование для обновления в текущем координаторе
    /// - Parameters:
    ///   - instance: передаваемые данные
    ///   - sourceTransmitter: координатор - источник передачи. Используется для исключения передачи данных в обратном направлении
    func transmit(data: TransmittedData, sourceCoordinator source: Coordinator) -> Void {
        self.use(transmittedData:data)
        if self.rootCoordinator !== source {
            (self.rootCoordinator as? Transmitter)?.transmit(data: data, sourceCoordinator: self)
        }
        self.childCoordinators.forEach{ coordinator in
            if coordinator !== source {
                (coordinator as? Transmitter)?.transmit(data: data, sourceCoordinator: self)
            }
        }
    }
    
    
    /// Использование данных внутри координатора для обновления  анных
    /// - Parameter data: данные, на основе которых происходит обновление
    func use(transmittedData data: TransmittedData) -> Void {
        // Данные отправляются в текущий трансмиттер
        useInThisTransmitter(data: data)
        
        // Если Координатора является Презентором, то данные отправляются в корневой презентор (контроллер)
        // и дочерние контроллеры
        guard self is Presenter else {
            return
        }
        ((self as! Presenter).presenter as? TransmittedDataHandler)?.handle(transmittedData: data)
        (self as! Presenter).childControllers.forEach { childViewController in
            (childViewController as? TransmittedDataHandler)?.handle(transmittedData: data)
        }
    }
}

protocol TransmittedDataHandler where Self: UIViewController {
    func handle(transmittedData: TransmittedData)
}
