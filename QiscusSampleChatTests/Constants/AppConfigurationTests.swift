//
//  AppConfigurationTests.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 24/04/24.
//

import XCTest
@testable import QiscusSampleChat

class AppConfigurationTests: XCTestCase {
  
  var userLocalDB: MockUserLocalDateBase!
  
  override func setUp() {
    super.setUp()
    userLocalDB = MockUserLocalDateBase()
  }
  
  override func tearDown() {
    super.tearDown()
    userLocalDB = nil
    AppConfiguration.userEmail = nil
  }
  
  func tesAppConfiguration_WhenAppStarts_AppIdNotEmpty() {
    XCTAssertNotEqual(AppConfiguration.APP_ID, "")
  }
  
  func testAppConfiguration_WhenAppStarts_AppIdNotEqual() {
    XCTAssertNotEqual(AppConfiguration.APP_IDENTIFIER, "QiscusApp")
  }
  
  func testAppConfiguration_WhenIsMyMessageAndUserLocalIsNil_ShoulBeReturnFalse() {
    let result = AppConfiguration.isMyMessage(senderEmail: "someEmail", userLocal: nil)
    XCTAssertFalse(result)
  }
  
  func testAppConfiguration_WhenIsMyMessageAndUserActiveIsNil_ShoulBeReturnFalse() {
    let result = AppConfiguration.isMyMessage(senderEmail: "someEmail", userLocal: userLocalDB)
    XCTAssertFalse(result)
  }
  
  func testAppConfiguration_WhenIsMyMessage_ShoulBeReturnTrue() {
    let isSave = userLocalDB.saveUser(user: UserActive(id: "1", email: "someEmail"))
    
    let result = AppConfiguration.isMyMessage(senderEmail: "someEmail", userLocal: userLocalDB)
    
    XCTAssertTrue(isSave)
    XCTAssertTrue(result)
  }
}
