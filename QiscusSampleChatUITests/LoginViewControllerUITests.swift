//
//  LoginViewControllerUITests.swift
//  LoginViewControllerUITests
//
//  Created by Admin on 21/04/24.
//

import XCTest

final class LoginViewControllerUITests_FirstSetup: XCTestCase {
  
  var app: XCUIApplication!
  var logoImageView: XCUIElement!
  var userIdTextField: XCUIElement!
  var userKeyTextField: XCUIElement!
  var userNameTextField: XCUIElement!
  var loginButton: XCUIElement!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    app = XCUIApplication()
    app.launch()
    
    logoImageView = app.images["logoImageView"]
    userIdTextField = app.textFields["userIdTextField"]
    userKeyTextField = app.textFields["userKeyTextField"]
    userNameTextField = app.textFields["userNameTextField"]
    loginButton = app.buttons["loginButton"]
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
    app = nil
    logoImageView = nil
    userIdTextField = nil
    userKeyTextField = nil
    userNameTextField = nil
    loginButton = nil
  }
  
  func testLoginViewController_WhenFirstSetup_AllComponnentsAreReady() {
    XCTAssertTrue(logoImageView.isEnabled)
    XCTAssertTrue(userIdTextField.isEnabled)
    XCTAssertTrue(userKeyTextField.isEnabled)
    XCTAssertTrue(userNameTextField.isEnabled)
    XCTAssertFalse(loginButton.isEnabled)
  }
  
  func testLoginViewController_WhenValidValueProvided_LoginButtonIsEnabled() {
    userIdTextField.tap()
    userIdTextField.typeText("bila75")
    
    userKeyTextField.tap()
    userKeyTextField.typeText("bila75")
    
    userNameTextField.tap()
    userNameTextField.typeText("ariefnur")
    
    logoImageView.tap()
    
    loginButton.tap()
    
    XCTAssertTrue(loginButton.isEnabled)
  }
  
  func testLoginViewController_WhenValidValueProvidedAndLoginButtonTapped_ShowAlertSuccess() {
    userIdTextField.tap()
    userIdTextField.typeText("bila75")
    
    userKeyTextField.tap()
    userKeyTextField.typeText("bila75")
    
    userNameTextField.tap()
    userNameTextField.typeText("ariefnur")
    
    logoImageView.tap()
    
    loginButton.tap()
    
    let alert = app.alerts["successAlertDialog"]
    
    XCTAssertTrue(loginButton.isEnabled)
    XCTAssertTrue(alert.waitForExistence(timeout: 5))
    
    alert.scrollViews.otherElements.buttons["OK"].tap()
    XCTAssertFalse(alert.exists)
  }
  
  func testLoginViewController_WhenValidValueProvidedAndLoginButtonTapped_ShowAlertError() {
    userIdTextField.tap()
    userIdTextField.typeText(" ")
    
    userKeyTextField.tap()
    userKeyTextField.typeText("testerror")
    
    userNameTextField.tap()
    userNameTextField.typeText("testerror")
    
    logoImageView.tap()
    
    loginButton.tap()
    
    let alert = app.alerts["errorAlertDialog"]
    
    XCTAssertTrue(loginButton.isEnabled)
    XCTAssertTrue(alert.waitForExistence(timeout: 5))
    
    alert.scrollViews.otherElements.buttons["OK"].tap()
    XCTAssertFalse(alert.exists)
  }
  
//  func testLaunchPerformance() throws {
//    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//      // This measures how long it takes to launch your application.
//      measure(metrics: [XCTApplicationLaunchMetric()]) {
//        XCUIApplication().launch()
//      }
//    }
//  }
}
