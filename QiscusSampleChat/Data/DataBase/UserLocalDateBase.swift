//
//  UserLocalDateBase.swift
//  QiscusSampleChat
//
//  Created by Admin on 23/04/24.
//

import Foundation

protocol UserLocalDateBaseProtocol {
  func saveUser(user: UserActive) -> Bool
  
  func getUser() -> UserActive?
  
  func clearUser() -> UserActive?
  
  func saveToken(token: String)
  
  func getToken() -> String
}

private struct UserKey {
    let userActive = "userActive"
    let token = "token"
}

class UserLocalDateBase {
  
  private let key = UserKey()
  private let persistent: UserDefaults
  private let jsonUtils: JsonUtilsProtocol.Type
  
  private var userActiveString: String {
      get {
          return persistent.string(forKey: key.userActive) ?? ""
      }
      set {
          persistent.set(newValue, forKey: key.userActive)
      }
  }
  
  private var tokenString: String {
      get {
          return persistent.string(forKey: key.token) ?? ""
      }
      set {
          persistent.set(newValue, forKey: key.token)
      }
  }
  
  init(
    persistent: UserDefaults = .standard,
    jsonUtils: JsonUtilsProtocol.Type = JsonUtils.self
  ) {
    self.persistent = persistent
    self.jsonUtils = jsonUtils
  }
  
}

extension UserLocalDateBase: UserLocalDateBaseProtocol {
  
  func saveUser(user: UserActive) -> Bool {
    let userActive = jsonUtils.toJsonString(target: user)
    
    if !userActive.isEmpty {
      userActiveString = userActive
      return true
    }
    return false
  }
  
  func getUser() -> UserActive? {
    let user = userActiveString
    
    if !user.isEmpty {
      return jsonUtils.toModel(
        UserActive.self, from: user.data(using: .utf8)!
      )
    }
    return nil
  }
  
  func clearUser() -> UserActive? {
    if !userActiveString.isEmpty {
      let userActive = jsonUtils.toModel(
        UserActive.self, from: userActiveString.data(using: .utf8)!
      )

      userActiveString = ""
      tokenString = ""
      return userActive
    }
    return nil
  }
  
  func saveToken(token: String) {
    tokenString = token
  }
  
  func getToken() -> String {
    return tokenString
  }
  
}
