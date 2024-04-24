//
//  AppTests.swift
//  QisusSampleChatTests
//
//  Created by Admin on 24/04/24.
//

import XCTest
@testable import QisusSampleChat

class AppTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
  }
  
  override func tearDown() {
    super.tearDown()
    
  }
  
  func testConstants_WhenAppStarts_AppIdNotEmpty() {
   XCTAssertNotEqual(Constants.APP_ID, "")
  }
  
}
