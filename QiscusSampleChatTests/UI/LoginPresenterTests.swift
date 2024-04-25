//
//  LoginPresenterTests.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 22/04/24.
//

import XCTest
@testable import QiscusSampleChat

class LoginPresenterTests: XCTestCase {
  
  var presenter: LoginPresenter!
  var repository: MockRepository!
  
  override func setUp() {
    super.setUp()
    repository = MockRepository()
    presenter = LoginPresenter(
      repository: repository, delegate: self
    )
  }
  
  override func tearDown() {
    super.tearDown()
    presenter = nil
    repository = nil
  }
  
  func testLoginPresenter_WhenLogin_ReturnSuccess() {
    let expectation = self.expectation(description: "Expectation is succesfull() method to be called")
    repository.expectation = expectation
    repository.isSuccess = true
    
    repository.userActive = UserActive(id: "1", email: "test@mail.com", username: "test")
    
    let userId = "test@mail.com"
    let userkey = "test"
    let userName = "test"
    
    presenter.login(userId: userId, userkey: userkey, userName: userName)
    self.wait(for: [expectation], timeout: 1)
    
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  func testLoginPresenter_WhenLogin_ReturnError() {
    let expectation = self.expectation(description: "Expectation is failed() method to be called")
    repository.expectation = expectation
    
    repository.error = UserError.custom(message: "Login failed")
    
    let userId = "test@mail.com"
    let userkey = "test"
    let userName = "test"
    
    presenter.login(userId: userId, userkey: userkey, userName: userName)
    self.wait(for: [expectation], timeout: 1)
    
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
}

extension LoginPresenterTests: LoginPresenter.LoginDelegate {
  func onSuccess(userActive: UserActive) {
    if !repository.isSuccess {
      XCTFail("LoginPresenterTests OnSuccess whit error \(String(describing: repository.error?.localizedDescription))")
    } else {
      XCTAssertNotNil(repository.userActive)
      XCTAssertEqual(userActive.email, repository.userActive!.email)
    }
  }
  
  func onError(error: UserError) {
    if repository.isErrorLogout {
      XCTFail("LoginPresenterTests OnError whit error \(String(describing: repository.error?.localizedDescription))")
    } else {
      XCTAssertNotNil(repository.error)
      XCTAssertEqual(error, repository.error)
    }
  }
}
