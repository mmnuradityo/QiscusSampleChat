//
//  LoginPresenterTests.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 22/04/24.
//

import XCTest
@testable import QiscusSampleChat

class LoginPresenterTests: XCTestCase {
  
  var sut: LoginPresenter!
  var delegate: LoginPresenterTestsDelegate!
  var repository: MockRepository!
  
  override func setUp() {
    super.setUp()
    delegate = LoginPresenterTestsDelegate()
    repository = MockRepository()
    
    sut = LoginPresenter(
      repository: repository, delegate: delegate
    )
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    repository = nil
    delegate = nil
  }
  
  func testLoginPresenter_WhenLogin_ReturnSuccess() {
    let expectation = self.expectation(description: "Expectation is succesfull() method to be called")
    repository.expectation = expectation
    repository.isSuccess = true
    delegate.isSuccess = true
    
    let user = UserActive(id: "1", email: "test@mail.com", username: "test")
    repository.userActive = user
    delegate.userActive = user
    
    let userId = "test@mail.com"
    let userkey = "test"
    let userName = "test"
    
    sut.login(userId: userId, userkey: userkey, userName: userName)
    self.wait(for: [expectation], timeout: 1)
    
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  func testLoginPresenter_WhenLogin_ReturnError() {
    let expectation = self.expectation(description: "Expectation is failed() method to be called")
    repository.expectation = expectation
    
    let error = UserError.custom(message: "Login failed")
    repository.error = error
    delegate.error = error
    
    let userId = "test@mail.com"
    let userkey = "test"
    let userName = "test"
    
    sut.login(userId: userId, userkey: userkey, userName: userName)
    self.wait(for: [expectation], timeout: 1)
    
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
}

class LoginPresenterTestsDelegate: LoginPresenter.LoginDelegate {
  
  var isSuccess = false
  var isErrorLogout = false
  var userActive: UserActive?
  var error: Error?
  
  func onSuccess(userActive: UserActive) {
    if !isSuccess {
      XCTFail("LoginPresenterTests OnSuccess whit error \(String(describing: error?.localizedDescription))")
    } else {
      XCTAssertNotNil(userActive)
      XCTAssertEqual(userActive.email, self.userActive!.email)
    }
  }
  
  func onError(error: UserError) {
    if isErrorLogout {
      XCTFail("LoginPresenterTests OnError whit error \(String(describing: error.localizedDescription))")
    } else {
      XCTAssertNotNil(error)
      XCTAssertEqual(error, self.error as! UserError)
    }
  }
}
