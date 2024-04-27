//
//  MessageModel.swift
//  QiscusSampleChat
//
//  Created by Admin on 26/04/24.
//

import Foundation

struct MessageModel {
 
  let id: Int
  let time: String
  let dateTime: String
  let status: Status
  let chatFrom: ChatFrom
  let data: MessageDataModel
  let sender: MessageSenderModel
  var isFirst: Bool
  
  init(
    id: Int,
    time: String,
    dateTime: String,
    status: Status,
    chatFrom: ChatFrom,
    data: MessageDataModel,
    sender: MessageSenderModel,
    isFirst: Bool = false
  ) {
    self.id = id
    self.time = time
    self.dateTime = dateTime
    self.status = status
    self.chatFrom = chatFrom
    self.data = data
    self.sender = sender
    self.isFirst = isFirst
  }
  
  enum ChatFrom {
    case me
    case other
  }
  
  enum Status {
    case read
    case delivered
    case sending
    case failed
    case none
  }
}
