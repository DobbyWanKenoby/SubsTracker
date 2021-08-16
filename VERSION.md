**toDO:** Add function of remove Subscription
**toDO:** Add function of create payments for Subscriptions during initialization of app


### 0.3.3
- Added function of subscription removing
- Added function of payment removing

### 0.3.2
- Updated SCK core version to 1.0.7
- A lot of fix with internationalization and localization 
- Fixed input amount field (added Locals formats with "." and ",")
- Fixed work of currency adn number formatter
- Amount (price) now is a Decimal value
- Added alert during editing subscription when Next/First Payment Date < current date
- Another fixes

### 0.3.1
- Updated SCK core version to 1.0.6
- Integrated SCK App & Scene Coordinators
- Fixed bugs (after updating SCK)

### 0.3.0
- Updated SCK core version to 1.0.2
- AppCoordinator & SceneCoordinator added

### 0.2.5
- Added UITests Target
- Added UITest for testing creation of subscription
- Added first Accessibilities
- Added ACIdentifier enum and setAccessibility function for set accessibilities of UI elements

### 0.2.4
- Full update layout of Add Scbscription Screen
- Updated all cells (include to CellFactory). Change TextField in PickerCell & DatePickerCell to Label 
- Fix logic of autochanging tableView insets when keyboard show
- Updated SCK to version 0.3.1
- Update structure of Coordinators
- Added autoupdate of subscriptions nexPaymentDate during save and update subscription instance
- Added new instance Payment (struct & CoreData Entity)
- Added new PaymentMicroService
- Added Payment Success function
- Fixed problem with TimeZone and payment's date

### 0.2.3
- Renamed MicroServices
- Updated Create TableViewCells system. Added CellFactory and Protocols
- Updated Picker Cell (now using Label except text Field)
- Updated TextField Cell

### 0.2.2
- Add SubDescription to Subscription Card on SubscriptionList Scene
- Fixed bug with navigation bar opacity animation in EditSubscription Scene
- Fixed bug with navigation bar opacity in SubscriptionList Scene
- Added set default currency (based on Locale)
- Fixed bug with using default currency on Add/Edit Subscription Scene
- Updated ActionsList for All Textfields on Add/Edit Subscription Scene
- Updated Localization
- Added initialization logic
- Added Setting Microservice

### 0.2.1
- Updated SCK to version 0.3.0
- Added EditSubscription Scene
- Updated Add/Edit Subscription Controller
- Updated transition animation in AddSubscription Scene
- Used new routing system (SCK)
