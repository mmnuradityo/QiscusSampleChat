//
//  UserLocalDataBaseTeste.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 23/04/24.
//

import XCTest
@testable import QiscusSampleChat

class UserLocalDataBaseTeste: XCTestCase {
  
  var sut: UserLocalDateBase!
  var userPersistance: MockUserPersistance!
  var jsonUtils: JsonUtilsProtocol.Type!
  var userActive: UserActive!
  
  override func setUp() {
    super.setUp()
    userActive = UserActive(id: "1", email: "email@mail.com")
    userPersistance = MockUserPersistance()
    jsonUtils = MockJsonUtils.self
    sut = UserLocalDateBase(persistent: userPersistance, jsonUtils: jsonUtils)
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    userPersistance = nil
    jsonUtils = nil
    userActive = nil
  }
  
  func testUserLocalDateBase_WhenSaveUserWithInvalidProvided_ShouldReturnFalse() {
    let isSaved = sut.saveUser(user: userActive)
    
    XCTAssertFalse(isSaved)
  }
  
  func testUserLocalDateBase_WhenSaveUserWithValidProvided_ShouldReturnTrue() {
    MockJsonUtils.result = "{\"id\":\"1\",\"email\":\"email@mail.com\"}"
    
    let isSaved = sut.saveUser(user: userActive)
    
    XCTAssertTrue(isSaved)
  }
  
  func testUserLocalDateBase_WhenGetUserFailed_ShouldReturnNil() {
    let user = sut.getUser()
    
    XCTAssertNil(user)
  }
  
  func testUserLocalDateBase_WhenGetUserSuccess_ShouldReturnUserActive() {
    userPersistance.isSavedSuccess = true
    MockJsonUtils.userActive = userActive
    
    let user = sut.getUser()
    
    XCTAssertNotNil(user)
    XCTAssertEqual(user!.email, userActive.email)
  }
  
  func testUserLocalDateBase_WhenClearUserFailed_ShouldReturnNil() {
    let user = sut.clearUser()
    
    XCTAssertNil(user)
  }
  
  func testUserLocalDateBase_WhenClearUserSuccess_ShouldReturnUserActive() {
    userPersistance.isSavedSuccess = true
    MockJsonUtils.userActive = userActive
    
    let user = sut.clearUser()
    
    XCTAssertNotNil(user)
  }
  
}
