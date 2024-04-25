//
//  MockRepository.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 24/04/24.
//

import XCTest
@testable import QiscusSampleChat

class MockRepository: RepositoryProtocol {
  
  var expectation: XCTestExpectation?
  var error: UserError?
  var userActive: UserActive?
  var methodCalledCount = 0
  var isSuccess = false
  var isErrorLogout = false
  
  func login(userRequest: QiscusSampleChat.UserRequest, onSuccess: @escaping (QiscusSampleChat.UserActive) -> Void, onError: @escaping (QiscusSampleChat.UserError) -> Void) {
    if let error = error {
      onError(error)
    } else if let user = userActive {
      onSuccess(user)
    }
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  func getUserActive() -> QiscusSampleChat.UserActive? {
    methodCalledCount += 1
    return userActive
  }
  
  func logout(completion: @escaping (QiscusSampleChat.UserError) -> Void) {
    if let error = error {
      if isErrorLogout {
        completion(error)
      }
    }
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  
}
