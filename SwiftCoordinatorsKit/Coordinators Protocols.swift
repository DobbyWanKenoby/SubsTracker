import UIKit

// MARK: - Coordinator
// Координаторы предназначены для управления приложением.
// В их задачу входит
// - хранение иерархии координаторов (структура данных Деерво) (см. protocol Coordinator)
// - управление потоками (flow) (см. protocol Coordinator)
// - создают и отображают экраны (см. protocol Presenter)
// - передают данные между друг другом (см. protocol Transmitter)
// - передают данные в зависимые экраны (см. protocol Transmitter)
// - орабатывают поступившие данные  (см. protocol DataService)
// - обрабатывают запросы и отвечают на них (см. protocol DataService)

protocol Coordinator: AnyObject {
    var rootCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    func startFlow()
    func finishFlow()
}

// MARK: - Presenter
// Координатор-презентор отвечает за отображение данных на экране

protocol Presenter where Self: Coordinator {
    var childControllers: [UIViewController] { get set }
    var presenter: UIViewController? { get set }
}

// MARK: - Transmitter
// Координаторы-трансмиттеры образуют сеть передачи данных.
// Они обеспечивают церкуляцию данных в приложении

// Алиас типа передаваемых данных
// Массив может содержать сразу много различных данных
// каждые из которых могут быть приняты и обработаны своим координатором-сервисом (DataService)
typealias TransmittedData = [Any]

/// Координатор-трансмиттер может передавать данные дальше в цепочке трансмиттеров.
/// Данные передаются родительскому и дочерним координаторам
protocol Transmitter where Self: Coordinator{
    /// Передача данных во всех связанные координаторы и контроллеры
    /// - Parameters:
    ///   - data: передаваемые данные
    ///   - sourceCoordinator: координатор-источник
    func transmit(data : TransmittedData, sourceCoordinator: Coordinator) -> [Any]
}

extension Transmitter {
    
    private func transmitAndHandleDataInCoordinator(data: TransmittedData, coordinator: Coordinator, sourceCoordinator: Coordinator) -> [Any] {
        var response: [Any] = []
        
        print( "\(self) - \(coordinator)" )
        
        guard coordinator !== sourceCoordinator else {
            print("coordinator is source")
            return []
        }
        
        // передача данных в трансмиттер
        // если он конечно трансмиттер
        if let transmitter = coordinator as? Transmitter {
            let transmitResponse = transmitter.transmit(data: data, sourceCoordinator: self)
            if transmitResponse.count > 0 {
                response += transmitResponse
            }
        }
        
        // передача данных в сервис для обработки
        // если он конечно сервис
        if let service = coordinator as? DataService {
            // каждые данные передаются отдельно
            data.forEach { dataItem in
                if let dataRequest = dataItem as? DataRequest {
                    let serviceResponse = service.handle(data: dataRequest)
                    if serviceResponse != nil {
                        response.append(serviceResponse!)
                    }
                }
            }
        }
        
        return response
    }
    
    /// Передача данных в связанные координаторы
    /// - Parameters:
    ///   - data: передаваемые данные
    ///   - sourceCoordinator: координатор - источник передачи. Используется для исключения передачи данных в обратном направлении
    func transmit(data: TransmittedData, sourceCoordinator source: Coordinator) -> [Any] {
        
        var response: [Any] = []
        
        if let root = rootCoordinator {
            response += transmitAndHandleDataInCoordinator(data: data, coordinator: root, sourceCoordinator: source)
        }
        
        childCoordinators.forEach { child in
            response += transmitAndHandleDataInCoordinator(data: data, coordinator: child, sourceCoordinator: source)
        }
        return response
    }
}


/// Наделяет вью контроллер возможность обрабатывать передаваемые Координаторами данные
/// Если контроллер должен принимать хоть какие-то данные для обработки, то его необходимо подписать на данный протокол
protocol TransmittedDataHandler where Self: UIViewController {
    func handle(transmittedData: TransmittedData)
}

// MARK: - DataHandler


/// Запрос на получение каких-либо данных
/// Запросы передаются трансмиттерами и обрабатываются сервисами
protocol DataRequest {}

/// Ответ на запрос
protocol DataResponse {}

/// Сервис обработки данных
protocol DataService where Self: Coordinator {
    func handle(data: DataRequest) -> DataResponse?
}
