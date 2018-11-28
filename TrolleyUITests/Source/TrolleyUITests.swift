import XCTest

class TrolleyUITests: XCTestCase {
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    let app = XCUIApplication()
    
    // MARK: - general Methods
    func waitForElement(_ element: XCUIElement, _ toExist: Bool = true, _ timeOut: Double = 5.0) {
        let predicate = NSPredicate(format: "exists == \(toExist)")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeOut)
        XCTAssertTrue(result == .completed, "Wait for element \(element) with existence as \(toExist) timed out after \(timeOut) seconds.")
    }
    
    func tapElement(element: XCUIElement, elementName: String = "Element") {
        waitForElement(element, true, 10.0)
        element.tap()
    }
    
    func typeIntoTextField(element: XCUIElement , textFieldValue: String) {
        tapElement(element: element)
        element.typeText(textFieldValue)
    }
    
    // MARK: - Authentication test Methods
    func test_integrationCase01_signin() {
        if !app.buttons["sign in"].exists{
            app.buttons["sign out"].tap()
        }
        waitForElement(app.textFields.element(boundBy: 0), true, 2.0) //verify user is on sign in screen
        typeIntoTextField(element: app.textFields.element(boundBy: 0), textFieldValue: "test@test")
        app.buttons["sign in"].tap()
        XCTAssertTrue(app.buttons["sign out"].waitForExistence(timeout: 2.0), "Sign in failed")
        app.buttons["sign out"].tap() // bring back to clean start state
    }
    
    func test_integrationCase02_signout() {
        if app.buttons["sign in"].exists{
            typeIntoTextField(element: app.textFields.element(boundBy: 0), textFieldValue: "test@test")
            app.buttons["sign in"].tap()
        }
        
        app.buttons["sign out"].tap()
        XCTAssertTrue(app.buttons["sign in"].waitForExistence(timeout: 2.0), "Sign out failed")
    }
    
    func test_integrationCase03_signoutAndSigninDifferentUser() {
        if !app.buttons["sign in"].exists{
            app.buttons["sign out"].tap()
        }
        waitForElement(app.textFields.element(boundBy: 0), true, 2.0) //verify user is on sign in screen
        typeIntoTextField(element: app.textFields.element(boundBy: 0), textFieldValue: "test@test")
        app.buttons["sign in"].tap()
        
        let totalPrice = String(app.staticTexts.element(boundBy: 1).label)
        app.buttons["sign out"].tap()
        // different user sign in
        typeIntoTextField(element: app.textFields.element(boundBy: 0), textFieldValue: "test2@test")
        app.buttons["sign in"].tap()
        XCTAssertTrue(app.staticTexts.element(boundBy: 1).label != totalPrice, "Previous user data persisted")
    }
    
    // MARK: - Edit cart/ Store test Methods
    func test_integrationCase04_addItemsQtyVerificationInEditCart() {
        if app.buttons["sign in"].exists{
            typeIntoTextField(element: app.textFields.element(boundBy: 0), textFieldValue: "test@test")
            app.buttons["sign in"].tap()
        }
        
        app.navigationBars["Home"].buttons["Add"].tap()
        XCTAssertTrue(app.buttons["save"].waitForExistence(timeout: 2.0), "Add item button failed")
        
        var quantity: Int = Int(app.staticTexts.element(boundBy: 2).label)!
        let incrementButton = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).steppers.buttons["Increment"]
        incrementButton.tap()
        incrementButton.tap()
        quantity = quantity + 2
        let expectedQuantity = String(quantity)
        XCTAssertTrue(app.staticTexts.element(boundBy: 2).label == expectedQuantity, "Stepper not incremented correctly")
    }
    
    func test_integrationCase05_removeItemsQtyVerificationInEditCart() {
        if app.buttons["sign in"].exists{
            typeIntoTextField(element: app.textFields.element(boundBy: 0), textFieldValue: "test@test")
            app.buttons["sign in"].tap()
        }
        
        app.navigationBars["Home"].buttons["Add"].tap()
        XCTAssertTrue(app.buttons["save"].waitForExistence(timeout: 2.0), "Add item button failed")
        
        var quantity: Int = Int(app.staticTexts.element(boundBy: 2).label)!
        let decrementButton = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).steppers.buttons["Decrement"]
        decrementButton.tap()
        quantity = quantity - 1
        let expectedQuantity = String(quantity)
        XCTAssertTrue(app.staticTexts.element(boundBy: 2).label == expectedQuantity, "Quantity not updated in My Cart")
    }
    
    // MARK: - My cart test Methods
    func test_integrationCase06_addItemsQtyVerificationInMyCart() {
        if app.buttons["sign in"].exists{
            typeIntoTextField(element: app.textFields.element(boundBy: 0), textFieldValue: "test@test")
            app.buttons["sign in"].tap()
        }
        
        app.navigationBars["Home"].buttons["Add"].tap()
        XCTAssertTrue(app.buttons["save"].waitForExistence(timeout: 2.0), "Add item button failed")
        
        var quantity: Int = Int(app.staticTexts.element(boundBy: 2).label)!
        let incrementButton = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).steppers.buttons["Increment"]
        incrementButton.tap()
        incrementButton.tap()
        quantity = quantity + 2
        let expectedQuantity = String(quantity)
        app.buttons["save"].tap()
        XCTAssertTrue(app.staticTexts.element(boundBy: 4).label == "Qty: \(expectedQuantity)", "Quantity not updated in My Cart")
    }
    
    func test_integrationCase07_removeItemsQtyVerificationInMyCart() {
        if app.buttons["sign in"].exists{
            typeIntoTextField(element: app.textFields.element(boundBy: 0), textFieldValue: "test@test")
            app.buttons["sign in"].tap()
        }
        
        app.navigationBars["Home"].buttons["Add"].tap()
        XCTAssertTrue(app.buttons["save"].waitForExistence(timeout: 2.0), "Add item button failed")
        
        var quantity: Int = Int(app.staticTexts.element(boundBy: 2).label)!
        let decrementButton = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).steppers.buttons["Decrement"]
        decrementButton.tap()
        quantity = quantity - 1
        let expectedQuantity = String(quantity)
        app.buttons["save"].tap()
        XCTAssertTrue(app.staticTexts.element(boundBy: 4).label == "Qty: \(expectedQuantity)", "Quantity not updated in My Cart")
    }
    
    func test_integrationCase08_addItemsPriceVerificationInMyCart() {
        if app.buttons["sign in"].exists{
            typeIntoTextField(element: app.textFields.element(boundBy: 0), textFieldValue: "test@test")
            app.buttons["sign in"].tap()
        }
        
        let priceString: String = String(app.staticTexts.element(boundBy: 5).label.suffix(4))
        var price: Double = Double(priceString)!
        
        app.navigationBars["Home"].buttons["Add"].tap()
        XCTAssertTrue(app.buttons["save"].waitForExistence(timeout: 2.0), "Add item button failed")
        
        let incrementButton = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).steppers.buttons["Increment"]
        incrementButton.tap()
        incrementButton.tap()
        
        price += (price*2)
        let expectedPrice = String(price)
        app.buttons["save"].tap()
        XCTAssertTrue(app.staticTexts.element(boundBy: 5).label == "$\(expectedPrice)", "Price not updated in My Cart")
    }
    
}
