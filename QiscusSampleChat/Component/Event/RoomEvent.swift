//
//  RoomEvent.swift
//  QiscusSampleChat
//
//  Created by Admin on 09/05/24.
//

import QiscusCore

class RoomEvent: BaseEvent<String>, QiscusCoreDelegate {
  
  func sendChatRoom(_ room: RoomModel, message: CommentModel?) {
    if let roomId = self.dataItem, roomId == room.id { return }
    var chatroom = room.toChatRoom()
    if message != nil {
      chatroom.lastMessage = message!.toMessage()
    }
    AppComponent.shared.getNotificationUtils().notify(chatroom: chatroom)
    observer?.onEventRoom(room: chatroom)
  }
  
  func sendMessage(message: CommentModel, changeStatus status: CommentStatus?) {
    if let roomId = self.dataItem, roomId == message.roomId { return }
    var message = message.toMessage()
    if status != nil {
      message.status = status!
    }
    observer?.onEventMessage(message: message)
  }
  
  func onRoomMessageReceived(_ room: RoomModel, message: CommentModel) {
    sendChatRoom(room, message: message)
  }
  
  func onRoomMessageUpdated(_ room: RoomModel, message: CommentModel) {
    sendChatRoom(room, message: message)
  }
  
  func onRoomMessageDeleted(room: RoomModel, message: CommentModel) {
    // do nothings
  }
  
  func onRoomDidChangeComment(comment: CommentModel, changeStatus status: CommentStatus) {
    sendMessage(message: comment, changeStatus: status)
  }
  
  func onRoomMessageDelivered(message: CommentModel) {
    sendMessage(message: message, changeStatus: nil)
  }
  
  func onRoomMessageRead(message: CommentModel) {
    sendMessage(message: message, changeStatus: nil)
  }
  
  func onRoom(update room: RoomModel) {
    sendChatRoom(room, message: nil)
  }
  
  func onRoom(deleted room: RoomModel) {
    // do nothings
  }
  
  func gotNew(room: RoomModel) {
    sendChatRoom(room, message: nil)
  }
  
  func onChatRoomCleared(roomId: String) {
    // do nothings
  }
  
  func onRefreshToken(event: QiscusRefreshTokenEvent) {
    // do nothings
  }
  
}

