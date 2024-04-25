//
//  LoginRequest.swift
//  QiscusSampleChat
//
//  Created by Admin on 23/04/24.
//

import Foundation

struct UserRequest {
  
  let userId: String
  let username: String
  let userKey: String
  let avatarURL: URL?
  let extras: [ String : Any]?
  
  init(userId: String, userKey: String, username: String, avatarURL: URL?, extras: [ String : Any]?) {
    self.userId = userId
    self.userKey = userKey
    self.username = username
    self.avatarURL = avatarURL
    self.extras = extras
  }
  
}
