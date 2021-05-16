# SubsTracker


Приложение "SubsTracker" - менеджер подписок и регулярных платежей для iOS.

**Используемая архитектура:** MVC + Координаторы/Микросервисы на основе [SwiftCoordinatorsKit](https://github.com/DobbyWanKenoby/SubsTracker/tree/main/SwiftCoordinatorsKit)


## Известные проблемы
1. `AddSubscriptionController` иммеет retain cycle (на него ссылаются элементы его же ячеек), поэтому сцена после скрытия с экрана не удаляется из памяти. Временно для устранения перерасхода памяти `ControllerFactory` возвращает один и тот же экземпляр `AddSubscriptionController` в соответствующем методе.


