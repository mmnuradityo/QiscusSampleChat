//
//  Repository.swift
//  QiscusSampleChat
//
//  Created by Admin on 23/04/24.
//

import QiscusCore

protocol RepositoryProtocol {
  func login(
    userRequest: UserRequest,
    onSuccess: @escaping (UserActive) -> Void,
    onError: @escaping (UserError) -> Void
  )
  
  func getUserActive() -> UserActive?
  
  func logout(completion: @escaping (UserError) -> Void)
}

class Repository: RepositoryProtocol {
  let dataStore: DataStoreProtocol
  let qiscusManager: QiscusManagerProtocol
  
  init(dataStore: DataStoreProtocol, qiscusManager: QiscusManagerProtocol) {
    self.dataStore = dataStore
    self.qiscusManager = qiscusManager
  }
  
  func login(
    userRequest: UserRequest,
    onSuccess: @escaping (UserActive) -> Void,
    onError: @escaping (UserError) -> Void
  ) {
    qiscusManager.login(userRequest: userRequest) { userModel in
      let userActive = userModel.toUserActive()
      let isSaved = self.dataStore.getUserLocalDateBase().saveUser(user: userActive)
      
      if isSaved {
        self.dataStore.getUserLocalDateBase().saveToken(token: userModel.token)
        onSuccess(userActive)
      } else {
        onError(UserError.invalidSaveUser)
      }
      
    } onError: { qiscusError in
      onError(UserError.custom(message: qiscusError.message))
    }
  }
  
  func getUserActive() -> UserActive? {
    return dataStore.getUserLocalDateBase().getUser()
  }
  
  func logout(completion: @escaping (UserError) -> Void) {
    if let userActive = dataStore.getUserLocalDateBase().clearUser() {
      qiscusManager.logout { error in
        if let error = error {
          let userError = UserError.custom(message: error.message)
          completion(userError)
        }
        
        _ = self.dataStore.getUserLocalDateBase().saveUser(user: userActive)
      }
    }
  }
  
}
