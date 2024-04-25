//
//  AppTests.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 24/04/24.
//

import XCTest
@testable import QiscusSampleChat

class AppTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
  }
  
  override func tearDown() {
    super.tearDown()
    
  }
  
  func testConstants_WhenAppStarts_AppIdNotEmpty() {
   XCTAssertNotEqual(AppConfiguration.APP_ID, "")
  }
  
}
