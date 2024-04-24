//
//  MockQiscusManager.swift
//  QisusSampleChatTests
//
//  Created by Admin on 23/04/24.
//

import Foundation
@testable import QisusSampleChat
@testable import QiscusCore

class MockQiscusManager: QiscusManagerProtocol {
  var error: QError? = nil
  var isErrorButNotCalled = false
  
  func setupEngine() {
    // do nothing
  }
  
  func login(userRequest: UserRequest, onSuccess: @escaping (UserModel) -> Void, onError: @escaping (QError) -> Void) {
    if let error = error {
      onError(error)
    } else {
      onSuccess(UserModel())
    }
  }
  
  func logout(onError: @escaping (QError?) -> Void) {
    if let error = error {
      if !isErrorButNotCalled { onError(error) }
    }
  }
}
