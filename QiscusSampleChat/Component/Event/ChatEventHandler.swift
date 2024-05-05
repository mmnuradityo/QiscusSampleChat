//
//  ChatEventHandler.swift
//  QiscusSampleChat
//
//  Created by Admin on 01/05/24.
//

import QiscusCore

class ChatEventHandler: ChatEventHandlerProtocol {
  
  let repository: RepositoryProtocol
  var observer: ChatEventObserver?
  var roomId: String = ""
  
  init(repository: RepositoryProtocol) {
    self.repository = repository
  }
  
  func connectToQiscus() {
    repository.connectToQiscus(delegate: self)
  }
  
  func register(observerEvent: ChatEventObserver, roomId: String) {
    self.observer = observerEvent
    repository.subscribeChatRoom(delegate: self, roomId: roomId)
  }
  
  func removeObserver() {
    repository.unSubcribeChatRoom(roomId: roomId)
    roomId = ""
    observer = nil
  }
  
}

// MARK: ~ handle QiscusCoreRoomDelegate
extension ChatEventHandler: QiscusConnectionDelegate {
  
  func connectionState(change state: QiscusConnectionState) {
    // TODO:
  }
  
  func onConnected() {
    // TODO:
  }
  
  func onReconnecting() {
    // TODO:
  }
  
  func onDisconnected(withError err: QError?) {
    // TODO:
  }
  
}

// MARK: ~ handle QiscusCoreRoomDelegate
extension ChatEventHandler: QiscusCoreRoomDelegate {
  
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
    
  private func validate(roomId: String) -> Bool {
    return self.roomId == roomId
  }
}

protocol ChatEventHandlerProtocol {
  func connectToQiscus()
  func register(observerEvent: ChatEventObserver, roomId: String)
  func removeObserver()
}

protocol ChatEventObserver {
  func onEventRoom(room: ChatRoomModel)
  func onEventMessage(message: MessageModel)
}
