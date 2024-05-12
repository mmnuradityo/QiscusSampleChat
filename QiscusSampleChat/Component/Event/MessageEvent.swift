//
//  MessageEventHandler.swift
//  QiscusSampleChat
//
//  Created by Admin on 09/05/24.
//

import QiscusCore

class MessageEvent: BaseEvent<String>, QiscusCoreRoomDelegate {
  
  private func validate(roomId: String) -> Bool {
    return self.dataItem == roomId
  }
  
  func onMessageReceived(message: CommentModel) {
    if validate(roomId: message.roomId) {
      observer?.onEventMessage(message: message.toMessage())
    }
  }
  
  func onMessageUpdated(message: CommentModel) {
    if validate(roomId: message.roomId) {
      observer?.onEventMessage(message: message.toMessage())
    }
  }
  
  func didComment(comment: CommentModel, changeStatus status: CommentStatus) {
    if validate(roomId: comment.roomId) {
      observer?.onEventMessage(message: comment.toMessage())
    }
  }
  
  func onMessageDelivered(message: CommentModel) {
    if validate(roomId: message.roomId) {
      observer?.onEventMessage(message: message.toMessage())
    }
  }
  
  func onMessageRead(message: CommentModel) {
    if validate(roomId: message.roomId) {
      observer?.onEventMessage(message: message.toMessage())
    }
  }
  
  func onMessageDeleted(message: CommentModel) {
    //
  }
  
  func onUserTyping(userId: String, roomId: String, typing: Bool) {
    //
  }
  
  func onUserOnlinePresence(userId: String, isOnline: Bool, lastSeen: Date) {
    //
  }
  
  func onRoom(update room: RoomModel) {
    if validate(roomId: room.id) {
      observer?.onEventRoom(room: room.toChatRoom())
    }
  }
  
}
