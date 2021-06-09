import UIKit

// MARK: - Coordinator
// Координаторы предназначены для управления приложением.
// В их задачу входит
// - хранение иерархии координаторов (структура данных Дерево) (см. protocol Coordinator)
// - управление потоками (flow) (см. protocol Coordinator)
// - создают и отображают экраны (см. protocol Presenter)
// - передают данные между друг другом (см. protocol Transmitter)
// - передают данные в зависимые экраны (см. protocol Transmitter)
// - орабатывают поступившие данные и отвечают на них (см. protocol Receiver)

protocol Coordinator: AnyObject {
    var rootCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    func startFlow(finishCompletion: (() -> Void)?)
    func finishFlow()
    func removeChild(coordinator: Coordinator)
}

extension Coordinator {
    func removeChild(coordinator: Coordinator) {
        for (index, child) in childCoordinators.enumerated() {
            if child === coordinator {
                child.rootCoordinator = nil
                childCoordinators.remove(at: index)
            }
        }
    }
}

// MARK: - Presenter
// Координатор-презентор отвечает за отображение данных на экране

protocol Presenter where Self: Coordinator {
    var childControllers: [UIViewController] { get set }
    var presenter: UIViewController? { get set }
}

// MARK: - Signal Transmitter & Receiver

// Координаторы-трансмиттеры образуют сеть передачи данных.
// Они обеспечивают церкуляцию данных в приложении

// Координаторы-ресиверы могут принимать и обрабатывать передаваемые данные

// Передаваемые (transmit) и принимаемые/обрабатываемые (receive) данные должны быть подписаны на данный протокол
protocol Signal {}


// Координатор-трансмиттер может передавать данные дальше в цепочке трансмиттеров.
// Данные передаются родительскому и дочерним координаторам
// Ответ отправляется в координатор, отправивший сигнал (source)
protocol Transmitter where Self: Coordinator {
    // Передача данных в связанные координаторы и контроллеры
    // При таком запросе координатор не ожидает ответ
    // а если ответ все же будет , то он будет обработан в методе receive источника запроса
    //   - signal: передаваемые данные
    //   - answerReceiver: приемник ответа. В него будет отправляться ответ
    func broadcast(signal: Signal, withAnswerToReceiver: Receiver?)
    
    // Передача данных в связанные координаторы и контроллеры
    // При таком запросе координатор ожидает и обабатывает полученный ответ inline
    func broadcast(signalWithReturnAnswer: Signal) -> [Signal]
}

extension Transmitter {
    
    func broadcast(signalWithReturnAnswer signal: Signal) -> [Signal] {
        var coordinators: [Coordinator] = []
        var resultSignals: [Signal] = []
        self.send(signal: signal, handledCoordinators: &coordinators, resultSignals: &resultSignals)
        return resultSignals
    }
    
    func broadcast(signal: Signal, withAnswerToReceiver receiver: Receiver?) {
        var coordinators: [Coordinator] = []
        var resultSignals: [Signal] = []
        self.send(signal: signal, handledCoordinators: &coordinators, resultSignals: &resultSignals)
        resultSignals.forEach { oneSignalAnswer in
            print(6)
            receiver?.receive(signal: oneSignalAnswer)
        }
    }
    
    // Дальнейшая передача данных, но с учетом списка координаторов, которые уже обработали данный сигнал
    // Используется, чтобы исключить повторную обратную передачу
    private func send(signal: Signal, handledCoordinators: inout [Coordinator], resultSignals: inout [Signal]) {
        guard handledCoordinators.firstIndex(where: { $0 === self }) == nil else {
            return
        }
        handledCoordinators.append(self)
        
        // передача в дочерние контроллеры
        if let presenter = self as? Presenter {
            presenter.childControllers.forEach { childController in
                (childController as? Receiver)?.receive(signal: signal)
            }
        }
        
        if let root = rootCoordinator as? Transmitter {
            root.send(signal: signal, handledCoordinators: &handledCoordinators, resultSignals: &resultSignals)
        }
        childCoordinators.forEach { child in
            if let childReciever = child as? Receiver {
                print(childReciever)
                if let answer = childReciever.receive(signal: signal) {
                    // отправляем ответ обратно
                   // answerReceiver?.receive(signal: answer)
                    resultSignals.append(answer)
                }
            }
            
            if let childTransmitter = child as? Transmitter {
                childTransmitter.send(signal: signal, handledCoordinators: &handledCoordinators, resultSignals: &resultSignals)
            }
        }
    }
}

// Координатор-ресивер может обрабатывать принимаемые сигналы
protocol Receiver {
    @discardableResult
    func receive(signal: Signal) -> Signal?
}
