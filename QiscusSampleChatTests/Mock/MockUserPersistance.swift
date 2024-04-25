//
//  MockUserPersistance.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 23/04/24.
//

import Foundation
@testable import QiscusSampleChat

class MockUserPersistance: UserDefaults {
  
  var isSavedSuccess = false
  var userACtive: UserActive?
  
  override func string(forKey defaultName: String) -> String? {
    return isSavedSuccess ? "{\"id\":\"1\",\"email\":\"email@mail.com\"}" : nil
  }
  
  override func set(_ value: Any?, forKey defaultName: String) {
    
  }
}
