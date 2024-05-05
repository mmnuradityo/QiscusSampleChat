//
//  ChatViewControllerUITests.swift
//  QiscusSampleChatUITests
//
//  Created by Admin on 30/04/24.
//

import XCTest

final class ChatViewControllerUITests: XCTestCase {
  
  var app: XCUIApplication!
  
  var chatToolbarView: XCUIElement!
  var chatTableView: XCUIElement!
  var chatFormView: XCUIElement!
  var chatMenuView: XCUIElement!
  var floatingButton: XCUIElement!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
    
    app = XCUIApplication()
    app.launch()
    
    chatToolbarView = app.otherElements["chatToolbarView"]
    chatTableView = app.tables["chatTableView"]
    chatFormView = app.otherElements["chatFormView"]
    chatMenuView = app.otherElements["chatMenuView"]
    floatingButton = app.buttons["floatingButton"]
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
    app = nil
    chatToolbarView = nil
    chatTableView = nil
    chatFormView = nil
    chatMenuView = nil
    floatingButton = nil
  }
  
  func testChatViewController_WhenFirstSetup_AllComponnentsAreReady() {
    XCTAssertTrue(chatToolbarView.isEnabled)
    XCTAssertTrue(chatTableView.isEnabled)
    XCTAssertTrue(chatFormView.isEnabled)
    XCTAssertFalse(chatMenuView.exists)
    XCTAssertFalse(floatingButton.exists)
  }
  
  func testChatViewController_WhenLoadChatRoomData_AllComponnentsAreSetWithData() {
    XCTAssertFalse(chatToolbarView.images["avatarImageView"].label == "ImagePlaceholder")
    XCTAssertFalse(chatToolbarView.staticTexts["userNameLabel"].label.isEmpty)
    XCTAssertFalse(chatToolbarView.staticTexts["userMemberLabel"].label.isEmpty)
    XCTAssertTrue(chatTableView.cells.count > 1)
  }
  
  func testChatViewController_WhenSendMessageText_BubbleChatIsAppread() {
    let formtextfieldTextView = chatFormView.textViews["formTextField"]
    formtextfieldTextView.tap()
    formtextfieldTextView.typeText("UI Test")
    
    chatFormView.buttons["sendButton"].tap()
    
    let firstCell = chatTableView.cells.element(boundBy: 0)
    let chatLableCell = firstCell.staticTexts["textChatLabel"]
    
    XCTAssertTrue(chatLableCell.label == "UI Test")
  }
  
  func testChatViewController_WhenLogout_LoginViewControllerIsShow() {
    app.buttons["menuOptionsButton"].tap()
    
    let popupOptiosnMenuView = app.otherElements["popupOptiosnMenuView"]
    let logoutButton = popupOptiosnMenuView.buttons["logoutButton"]
    logoutButton.tap()
    
    let loginViewController = app.otherElements["loginViewController"]
    let exists = loginViewController.waitForExistence(timeout: 5)
    
    XCTAssertTrue(exists, "View controller did not appear")
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
