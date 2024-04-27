//
//  MessageSenderModel.swift
//  QiscusSampleChat
//
//  Created by Admin on 27/04/24.
//

import Foundation

struct MessageSenderModel {
  
  let id: Int
  let name: String
  let email: String
  let avatarUrl: URL?
  
  init(id: Int, name: String, email: String, avatarUrl: String) {
    self.id = id
    self.name = name
    self.email = email
    self.avatarUrl = URL(string: avatarUrl)
  }
  
}
