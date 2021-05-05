//
// Координаторы управляют всеми сценами, которые появляются в процессе работы
// Они передают данные между друг другом
// Они вызывают контроллеры, отображают их необходимым способом и передают в них данные

import UIKit

typealias FinishCompletionHandler = () -> Void

protocol Coordinatable: class {
    var rootCoordinator: Coordinatable? { get set }
    var childCoordinators: [Coordinatable] { get set }
    var childControllers: [UIViewController] { get set }
    var presenter: UIViewController { get set }
    init(presenter: UIViewController)
    func start()
}
