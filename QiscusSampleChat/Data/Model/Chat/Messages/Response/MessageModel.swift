//
//  MessageModel.swift
//  QiscusSampleChat
//
//  Created by Admin on 26/04/24.
//

import QiscusCore

struct MessageModel {
  
  let id: String
  let roomId: String
  let timeString: String
  let dateString: String
  let timeStamp: Date?
  var status: CommentStatus
  let chatFrom: ChatFrom
  var data: MessageDataModel
  var sender: MessageSenderModel
  var isShowDate: Bool
  var isFirst: Bool
  
  init(
    id: String,
    roomId: String,
    timeString: String,
    dateTime: String,
    timeStamp: Date?,
    status: CommentStatus,
    chatFrom: ChatFrom,
    data: MessageDataModel,
    sender: MessageSenderModel,
    isDateShow: Bool = false,
    isFirst: Bool = false
  ) {
    self.id = id
    self.roomId = roomId
    self.timeString = timeString
    self.dateString = dateTime
    self.timeStamp = timeStamp
    self.status = status
    self.chatFrom = chatFrom
    self.data = data
    self.sender = sender
    self.isShowDate = isDateShow
    self.isFirst = isFirst
  }
  
  enum ChatFrom {
    case me
    case other
  }
  
}
