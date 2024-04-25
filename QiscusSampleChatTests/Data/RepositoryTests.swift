//
//  RepositoryTests.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 23/04/24.
//

import XCTest
@testable import QiscusSampleChat
@testable import QiscusCore

class RepositoryTests_UserLoginAndLogout: XCTestCase {
  
  var userRequest: UserRequest!
  var qiscusManager: MockQiscusManager!
  var repository: RepositoryProtocol!
  var dataStore: DataStoreProtocol!
  var userLocalDateBase: MockUserLocalDateBase!
  
  override func setUp() {
    super.setUp()
    userRequest = UserRequest(
      userId: "1",
      userKey: "userKey",
      username: "userName",
      avatarURL: nil,
      extras: nil
    )
    
    qiscusManager =  MockQiscusManager()
    userLocalDateBase = MockUserLocalDateBase()
    dataStore = DataStore(userLocalDateBase: userLocalDateBase)
    
    repository = Repository(dataStore: dataStore, qiscusManager: qiscusManager)
  }
  
  override func tearDown() {
    super.tearDown()
    userRequest = nil
    qiscusManager = nil
    repository = nil
    dataStore = nil
    userLocalDateBase = nil
  }
  
  func testRepository_WhenInvalidLoginUserRequestProvided_OnErrorMustBeCalled() {
    qiscusManager.error = QError.init(message: "invalid login")
    
    repository.login(userRequest: userRequest) { userModel in
      XCTFail("Should not be called")
    } onError: { error in
      XCTAssertNil(self.repository.getUserActive())
      XCTAssertNotNil(self.qiscusManager.error)
      XCTAssertEqual(
        self.qiscusManager.error!.message, error.localizedDescription,
        "Error message should be equal with message \(error.localizedDescription)"
      )
    }
  }
  
  func testRepository_WhenSaveUserIsFailed_OnErrorMustBeCalled() {
    userLocalDateBase.isSaved = false
    
    repository.login(userRequest: userRequest) { userModel in
      XCTFail("Should not be called")
    } onError: { error in
      XCTAssertNil(self.repository.getUserActive())
      XCTAssertEqual(
        error, UserError.invalidSaveUser,
        "Error message should be equal with message \(error.localizedDescription)"
      )
    }
  }
  
  func testRepository_WhenValidLoginUserRequestProvided_OnSuccessMustBeCalled() {
    repository.login(userRequest: userRequest) { userModel in
      XCTAssertNotNil(userModel)
      XCTAssertNotNil(self.repository.getUserActive())
    } onError: { error in
      XCTFail("Should not be called")
    }
  }
  
  func testRepository_WhenLogoutFailed_OnErrorMustBeCalled() {
    let userActive = UserActive(id: "1", email: "email@mail.com")
    _ = userLocalDateBase.saveUser(user: userActive)
    qiscusManager.error = QError.init(message: "invalid logout")
    
    repository.logout { error in
      self.userLocalDateBase.isClear = false
      XCTAssertNotNil(self.repository.getUserActive())
      XCTAssertEqual(error.localizedDescription, self.qiscusManager.error!.message)
    }
  }
  
  func testRepository_WhenLogoutFailed_OnErrorNotBeCalled() {
    let userActive = UserActive(id: "1", email: "email@mail.com")
    _ = userLocalDateBase.saveUser(user: userActive)
    qiscusManager.error = QError.init(message: "invalid logout")
    qiscusManager.isErrorButNotCalled = true
    
    repository.logout { error in
      self.userLocalDateBase.isClear = false
      XCTFail("Should not be called")
    }
    XCTAssertNil(self.repository.getUserActive())
  }
  
  func testRepository_WhenLogoutButUserActiveIsNil_OnErrorNotBeCalled() {
    qiscusManager.error = QError.init(message: "invalid logout")
    qiscusManager.isErrorButNotCalled = true
    
    repository.logout { error in
      self.userLocalDateBase.isClear = false
      XCTFail("Should not be called")
    }
    XCTAssertNil(self.repository.getUserActive())
  }
  
  func testRepository_WhenLogoutSuccess_OnErrorNotBeCalled() {
    let userActive = UserActive(id: "1", email: "email@mail.com")
    _ = userLocalDateBase.saveUser(user: userActive)
    repository.logout { error in
      XCTFail("Should not be called")
    }
    XCTAssertNil(self.repository.getUserActive())
  }
  
}
