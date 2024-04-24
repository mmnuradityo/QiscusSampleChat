//
//  DataStore.swift
//  QisusSampleChat
//
//  Created by Admin on 23/04/24.
//

import Foundation

protocol DataStoreProtocol {
  init(userLocalDateBase: UserLocalDateBaseProtocol)
  
  func getUserLocalDateBase() -> UserLocalDateBaseProtocol
}

class DataStore: DataStoreProtocol {
  let userLocalDateBase: UserLocalDateBaseProtocol
  
  required init(userLocalDateBase: UserLocalDateBaseProtocol) {
    self.userLocalDateBase = userLocalDateBase
  }
  
  func getUserLocalDateBase() -> UserLocalDateBaseProtocol {
    return userLocalDateBase
  }
  
    
}
