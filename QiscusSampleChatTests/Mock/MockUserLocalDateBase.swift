//
//  MockUserLocalDateBase.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 23/04/24.
//

import Foundation
@testable import QiscusSampleChat

class MockUserLocalDateBase: UserLocalDateBaseProtocol {
  
  var isSaved = true
  var isClear = false
  var user: UserActive!
  var token: String = ""
  
  func saveUser(user: UserActive) -> Bool {
    if isSaved {
      self.user = user
    }
    return isSaved
  }
  
  func getUser() -> UserActive? {
    return isClear ? nil : user
  }
  
  func clearUser() -> UserActive? {
    self.isClear = true
    return user
  }
  
  func saveToken(token: String) {
    // TODO:
  }
  
  func getToken() -> String {
    // TODO:
    return token
  }
  
}
