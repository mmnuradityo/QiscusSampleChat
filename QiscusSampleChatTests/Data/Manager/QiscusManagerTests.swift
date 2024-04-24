//
//  QiscusManagerTests.swift
//  QisusSampleChatTests
//
//  Created by Admin on 23/04/24.
//

import XCTest
@testable import QisusSampleChat

class QiscusManagerTests: XCTestCase {
  
  var qiscusManager: QiscusManagerProtocol!
  
  override func setUp() {
    super.setUp()
    qiscusManager = QiscusManager()
  }
  
  override func tearDown() {
    super.tearDown()
    qiscusManager = nil
  }
  
  
}
