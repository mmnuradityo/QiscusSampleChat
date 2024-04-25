//
//  MockJson+Utils.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 23/04/24.
//

import Foundation
@testable import QiscusSampleChat

class MockJsonUtils: JsonUtilsProtocol {
  
  static var result = ""
  static var userActive: UserActive?
  
  static func toJsonString<T>(target: T) -> String where T : Decodable, T : Encodable {
    return result
  }
  
  static func toModel<T>(_ type: T.Type, from data: Data) -> T? where T : Decodable {
    return userActive as? T
  }
}
