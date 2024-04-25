//
//  UserModel.swift
//  QiscusSampleChat
//
//  Created by Admin on 23/04/24.
//

import QiscusCore

struct UserActive: Codable {
  let id: String
  let avatarUrl: URL
  let email: String
  let username: String
  let extras: String
  
  init(
    id: String,
    email: String,
    username: String = "",
    extras: String = "",
    avatarUrl: URL = URL(string: "http://")!
  ) {
    self.id = id
    self.email = email
    self.username = username
    self.extras = extras
    self.avatarUrl = avatarUrl
  }
  
}

// MARK: ~ mapper from qiscus UserModel to UserActive
extension UserModel {
  func toUserActive() -> UserActive {
    return UserActive(
      id: id,
      email: email,
      username: username,
      extras: extras,
      avatarUrl: avatarUrl
    )
  }
}
