//
//  MessageSenderModel.swift
//  QiscusSampleChat
//
//  Created by Admin on 27/04/24.
//

import Foundation

struct MessageSenderModel {
  
  let id: String
  let name: String
  let email: String
  var avatarImage: ImageModel
  
  init(id: String, name: String, email: String, avatarImage: ImageModel) {
    self.id = id
    self.name = name
    self.email = email
    self.avatarImage = avatarImage
  }
  
}
