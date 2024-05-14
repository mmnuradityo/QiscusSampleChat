//
//  QiscusEventDelegete.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 14/05/24.
//

import Foundation
@testable import QiscusCore

class QiscusEventConnectionDelegate: QiscusConnectionDelegate {
  func connectionState(change state: QiscusConnectionState) {
    // do nothings
  }
  
  func onConnected() {
    // do nothings
  }
  
  func onReconnecting() {
    // do nothings
  }
  
  func onDisconnected(withError err: QError?) {
    // do nothings
  }
}

class QiscusEventCoreDelegate: QiscusCoreDelegate {
  func onRoom(update room: RoomModel) {
    // do nothings
  }
  
  func onRoom(deleted room: RoomModel) {
    // do nothings
  }
  
  func onRoomMessageReceived(_ room: RoomModel, message: CommentModel) {
    // do nothings
  }
  
  func onRoomMessageUpdated(_ room: RoomModel, message: CommentModel) {
    // do nothings
  }
  
  func onRoomMessageDeleted(room: RoomModel, message: CommentModel) {
    // do nothings
  }
  
  func onRoomDidChangeComment(comment: CommentModel, changeStatus status: CommentStatus) {
    // do nothings
  }
  
  func onRoomMessageDelivered(message: CommentModel) {
    // do nothings
  }
  
  func onRoomMessageRead(message: CommentModel) {
    // do nothings
  }
  
  func gotNew(room: RoomModel) {
    // do nothings
  }
  
  func onChatRoomCleared(roomId: String) {
    // do nothings
  }
  
  func onRefreshToken(event: QiscusRefreshTokenEvent) {
    // do nothings
  }
  
}

class QiscusEventRoomDelegate: QiscusCoreRoomDelegate {
  func onMessageReceived(message: CommentModel) {
    // do nothings
  }
  
  func onMessageUpdated(message: CommentModel) {
    // do nothings
  }
  
  func didComment(comment: CommentModel, changeStatus status: CommentStatus) {
    // do nothings
  }
  
  func onMessageDelivered(message: CommentModel) {
    // do nothings
  }
  
  func onMessageRead(message: CommentModel) {
    // do nothings
  }
  
  func onMessageDeleted(message: CommentModel) {
    // do nothings
  }
  
  func onUserTyping(userId: String, roomId: String, typing: Bool) {
    // do nothings
  }
  
  func onUserOnlinePresence(userId: String, isOnline: Bool, lastSeen: Date) {
    // do nothings
  }
  
  func onRoom(update room: RoomModel) {
    // do nothings
  }
  
}
