//
//  SubscriptionsPlanUITests.swift
//  SubscriptionsPlanUITests
//
//  Created by Admin on 27.07.2021.
//

import XCTest
import SubscriptionsPlan

class SubscriptionsPlanUITests: XCTestCase {
    
    // Экземпляр запущенного приложения
    lazy private var app: XCUIApplication = {
        let app = XCUIApplication()
        app.launch()
        return app
    }()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //
    // Создание подписки на существующий сервис
    //
    func testCreateSubscriptionOnService() throws {
        // данные для заполнения и проверки
        let priceWrite = "123.093"
        let priceCorrect = "123.09"
        var currencySymbol = "" // будет заполнено позже
        var serviceTitle = "" // будет заполнено позже
        
        // переход к экрану создания подписки
        //tap(elementWithText: "New subscription", in: app.buttons)
        tap(elementWithText: ACIdentifier.newSubscriptionTab.rawValue, in: app.buttons)
        serviceTitle = app.cells.element(boundBy: 1).staticTexts.firstMatch.label
        tap(elementWithText: serviceTitle, in: app.staticTexts)
        tap(elementWithText: "AMOUNT", in: app.staticTexts)
        for char in priceWrite {
            keyboardTap(button: String(char))
        }
        
        //tap(elementWithText: "Done", in: app.buttons)
        
        //tapElement(withStaticText: "New subscription", in: app.tabBars.buttons)
        //tapElement(withStaticText: "MTS", in: nil)
//        app.tabBars.buttons["New subscription"].tap()
//        app.tables.cells.staticTexts["MTS"].tap()
//        sleep(2)
//        app.tables/*@START_MENU_TOKEN@*/.cells.textFields["0.00"]/*[[".cells.textFields[\"0.00\"]",".textFields[\"0.00\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
//        app.tables/*@START_MENU_TOKEN@*/.cells.textFields["0.00"]/*[[".cells.textFields[\"0.00\"]",".textFields[\"0.00\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.typeText("101.24")
//
//        app.tables.cells.staticTexts["CURRENCY"].tap()
//        app.pickerWheels.firstMatch.swipeUp()
//        let text = app.pickerWheels.firstMatch.value
//        print(text)

        //tablesQuerya.tap()
//        app/*@START_MENU_TOKEN@*/.pickerWheels["Euro (€)"].press(forDuration: 0.5);/*[[".pickers.pickerWheels[\"Euro (€)\"]",".tap()",".press(forDuration: 0.5);",".pickerWheels[\"Euro (€)\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
//
//        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
//        doneButton.tap()
//        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Every 1 month"]/*[[".cells.buttons[\"Every 1 month\"]",".buttons[\"Every 1 month\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//
//        let pickerWheel = app/*@START_MENU_TOKEN@*/.pickerWheels["1"]/*[[".pickers.pickerWheels[\"1\"]",".pickerWheels[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        pickerWheel/*@START_MENU_TOKEN@*/.press(forDuration: 1.1);/*[[".tap()",".press(forDuration: 1.1);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//
//        let monthPickerWheel = app/*@START_MENU_TOKEN@*/.pickerWheels["month"]/*[[".pickers.pickerWheels[\"month\"]",".pickerWheels[\"month\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        monthPickerWheel.swipeDown()
//        monthPickerWheel/*@START_MENU_TOKEN@*/.press(forDuration: 0.7);/*[[".tap()",".press(forDuration: 0.7);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        doneButton.tap()
//        tablesQuery.cells.containing(.staticText, identifier:"DESCRIPTION").children(matching: .textField).element.tap()
//        doneButton.tap()
//        tablesQuery.cells.containing(.button, identifier:"In 1 day(s)").element.swipeUp()
//        pickerWheel/*@START_MENU_TOKEN@*/.press(forDuration: 0.6);/*[[".tap()",".press(forDuration: 0.6);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        pickerWheel.swipeDown()
//        app/*@START_MENU_TOKEN@*/.pickerWheels["5"]/*[[".pickers.pickerWheels[\"5\"]",".pickerWheels[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
//        app/*@START_MENU_TOKEN@*/.pickerWheels["2"]/*[[".pickers.pickerWheels[\"2\"]",".pickerWheels[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
//        doneButton.tap()
//        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .table).element.tap()
//        tabBar.buttons["Payments"].tap()
//        app.statusBars.otherElements["Cellular"].tap()
//        newSubscriptionButton/*@START_MENU_TOKEN@*/.swipeLeft()/*[[".swipeUp()",".swipeLeft()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    // MARK: - Helpers
    
    // Тап по конкретному элементу
    private func tap(_ element: XCUIElement) {
        element.tap()
    }
    
    // Тап по элементу с текстом
    private func tap(elementWithText text: String, in rootElement: XCUIElementQuery) {
        rootElement[text].tap()
    }
    
    // Написать текст
    private func write(text: String, to element: XCUIElement) {
        
    }
    
    // Нажать кнопки на клавиатуре
    private func keyboardTap(button: String) {
        _ = app.keyboards.firstMatch.keys[button].tap()
    }
}
