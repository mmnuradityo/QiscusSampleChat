//
//  MockRepository.swift
//  QisusSampleChatTests
//
//  Created by Admin on 24/04/24.
//

import XCTest
@testable import QisusSampleChat

class MockRepository: RepositoryProtocol {
  
  var expectation: XCTestExpectation?
  var error: UserError?
  var userActive: UserActive?
  var methodCalledCount = 0
  var isSuccess = false
  var isErrorLogout = false
  
  func login(userRequest: QisusSampleChat.UserRequest, onSuccess: @escaping (QisusSampleChat.UserActive) -> Void, onError: @escaping (QisusSampleChat.UserError) -> Void) {
    if let error = error {
      onError(error)
    } else if let user = userActive {
      onSuccess(user)
    }
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  func getUserActive() -> QisusSampleChat.UserActive? {
    methodCalledCount += 1
    return userActive
  }
  
  func logout(completion: @escaping (QisusSampleChat.UserError) -> Void) {
    if let error = error {
      if isErrorLogout {
        completion(error)
      }
    }
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  
}
