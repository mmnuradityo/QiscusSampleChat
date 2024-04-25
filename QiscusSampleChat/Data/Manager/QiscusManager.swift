//
//  DataStore.swift
//  QiscusSampleChat
//
//  Created by Admin on 23/04/24.
//

import QiscusCore

protocol QiscusManagerProtocol {
  func setupEngine()
  
  func login(userRequest: UserRequest, onSuccess: @escaping (UserModel) -> Void, onError: @escaping (QError) -> Void)
  
  func logout(onError: @escaping (QError?) -> Void)
}

class QiscusManager: QiscusManagerProtocol {
  
  func setupEngine() {
    let appId = AppConfiguration.APP_ID
    QiscusCore.setup(AppID: appId ?? "")
  }
  
  func login(userRequest: UserRequest, onSuccess: @escaping (UserModel) -> Void, onError: @escaping (QError) -> Void) {
    QiscusCore.setUser(
      userId: userRequest.userId,
      userKey: userRequest.userKey,
      username: userRequest.username,
      avatarURL: userRequest.avatarURL,
      extras: userRequest.extras,
      onSuccess: onSuccess,
      onError: onError
    )
  }
  
  func logout(onError: @escaping (QError?) -> Void) {
    QiscusCore.clearUser(completion: onError)
  }
}
