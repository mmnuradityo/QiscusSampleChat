//
//  DataStoreTests.swift
//  QisusSampleChatTests
//
//  Created by Admin on 23/04/24.
//

import XCTest
@testable import QisusSampleChat

class DataStoreTests: XCTestCase {
  
  func testDataStore_WhenInit_QiscusCoreShouldBeNotNil() {
    let dataStore = QiscusManager(qiscusCore: MockQiscusCore())
    XCTAssertNotNil(dataStore.qiscusCore)
  }
  
}
