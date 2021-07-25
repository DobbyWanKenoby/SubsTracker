**toDO:** Add function of remove Subscription
**toDO:** Add function of create payments for Subscriptions (after create/update Sub and during initialization app)
**toDo:** Add alert during editing subscription when Next Payment Date < current date
**toDo:** On Create/Edit SubscriptionScreen title on next payment cell must be NEXT PAYMENT during editing and FIRST PAYMENT during creating


### 0.2.4
- Full update layout of Add Scbscription Screen
- Updated all cells (include to CellFactory). Change TextField in PickerCell & DatePickerCell to Label 
- Fix logic of autochanging tableView insets when keyboard show
- Updated SCK to version 0.3.1
- Update structure of Coordinators
- Added autoupdate of subscriptions nexPaymentDate during save and update subscription instance
- Added new instance Payment (struct & CoreData Entity)
- Added new PaymentMicroService

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