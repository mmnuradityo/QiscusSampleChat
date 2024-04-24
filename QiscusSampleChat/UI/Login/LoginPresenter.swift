//
//  LoginPresenter.swift
//  QisusSampleChat
//
//  Created by Admin on 23/04/24.
//

import Foundation

protocol LoginPresenterProtocol {
  func login(userId: String, userkey: String, userName: String)
}

class LoginPresenter: LoginPresenterProtocol {
  
  let repository: RepositoryProtocol
  let delegate: LoginDelegate
  
  init(repository: RepositoryProtocol, delegate: LoginDelegate) {
    self.repository = repository
    self.delegate = delegate
  }
  
  func login(userId: String, userkey: String, userName: String) {
    let userRequest = UserRequest(
      userId: userId, userKey: userkey, username: userName, avatarURL: nil, extras: nil
    )
    repository.login(userRequest: userRequest) { userActive in
      self.delegate.onSuccess(userActive: userActive)
    } onError: { error in
      self.delegate.onError(error: error)
    }
  }
  
  protocol LoginDelegate {
    func onSuccess(userActive: UserActive)
    func onError(error: UserError)
  }
}
