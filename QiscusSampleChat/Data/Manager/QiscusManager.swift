//
//  DataStore.swift
//  QiscusSampleChat
//
//  Created by Admin on 23/04/24.
//

import QiscusCore

protocol QiscusManagerProtocol {
  func setupEngine(appID: String, enableLogDebug: Bool)
  func login(userRequest: UserRequest, onSuccess: @escaping (UserModel) -> Void, onError: @escaping (QError) -> Void)
  func logout(completion: @escaping () -> Void)
  func registerDeviceToken(deviceToken: String, onSuccess: @escaping (Bool) -> Void, onError: @escaping (QError) -> Void)
  // load
  func getDataBase() -> QiscusDatabaseManager?
  func loadRooms(page: Int, limit: Int, onSuccess: @escaping ([RoomModel], Meta?) -> Void, onError: @escaping (QError) -> Void)
  func loadRoomWithMessage(roomId: String, onSuccess: @escaping (RoomModel, [CommentModel]) -> Void, onError: @escaping (QError) -> Void)
  func loadMoreMessages(roomId: String, lastMessageId: String, limit: Int, onSuccess: @escaping ([CommentModel]) -> Void, onError: @escaping (QError) -> Void)
  func downloadFile(url: URL, onSuccess: @escaping (URL) -> Void, onProgress: @escaping (Float) -> Void)
  // send
  func sendMessage(messageRequest: CommentModel, onSuccess: @escaping (CommentModel) -> Void, onError: @escaping (QError) -> Void)
  func uploadFileupload(file: FileUploadModel, onSuccess: @escaping (FileModel) -> Void, onError: @escaping (QError) -> Void, progress: @escaping (Double) -> Void)
  // event
  func markAsRead(roomId: String, messageId: String)
  func connectToQiscus(delegate: QiscusConnectionDelegate)
  func subscribeChatRooms(delegate: QiscusCoreDelegate)
  func unSubcribeChatRooms()
  func subscribeChatRoom(delegate: QiscusCoreRoomDelegate, roomId: String)
  func unSubcribeChatRoom(roomId: String)
}

class QiscusManager: QiscusManagerProtocol {
  
  func setupEngine(appID: String, enableLogDebug: Bool) {
    QiscusCore.setup(AppID: appID)
    QiscusCore.enableDebugMode(value: enableLogDebug)
  }
  
  func login(userRequest: UserRequest, onSuccess: @escaping (UserModel) -> Void, onError: @escaping (QError) -> Void) {
    QiscusCore.setUser(
      userId: userRequest.userId,
      userKey: userRequest.userKey,
      username: userRequest.username,
      avatarURL: userRequest.avatarURL,
      extras: userRequest.extras,
      onSuccess: onSuccess,
      onError: onError
    )
  }
  
  func logout(completion: @escaping () -> Void) {
    QiscusCore.clearUser { error in
      self.getDataBase()?.clear()
      completion()
    }
  }
  
  func registerDeviceToken(deviceToken: String, onSuccess: @escaping (Bool) -> Void, onError: @escaping (QError) -> Void) {
    if QiscusCore.hasSetupUser() {
      QiscusCore.shared.registerDeviceToken(token: deviceToken, onSuccess: onSuccess, onError: onError)
    }
  }
  
  // load
  func getDataBase() -> QiscusDatabaseManager? {
    return QiscusCore.database
  }
  
  func loadRooms(
    page: Int, limit: Int,
    onSuccess: @escaping ([RoomModel],Meta?) -> Void,
    onError: @escaping (QError) -> Void
  ) {
    QiscusCore.shared.getAllChatRooms(page: page, limit: limit, onSuccess: onSuccess, onError: onError)
  }
  
  func loadRoomWithMessage(
    roomId:  String,
    onSuccess: @escaping (RoomModel, [CommentModel]) -> Void,
    onError: @escaping (QError) -> Void
  ) {
    QiscusCore.shared.getChatRoomWithMessages(
      roomId: roomId, onSuccess: onSuccess, onError: onError
    )
  }
  
  func loadMoreMessages(
    roomId: String,
    lastMessageId: String,
    limit: Int,
    onSuccess: @escaping ([CommentModel]) -> Void,
    onError: @escaping (QError) -> Void
  ) {
    QiscusCore.shared.loadMore(
      roomID: roomId,
      lastCommentID: lastMessageId,
      after: false,
      limit: limit,
      onSuccess: onSuccess,
      onError: onError
    )
  }
  
  func downloadFile(url: URL, onSuccess: @escaping (URL) -> Void, onProgress: @escaping (Float) -> Void) {
    QiscusCore.shared.download(url: url, onSuccess: onSuccess, onProgress: onProgress)
  }
  
  // send
  
  func sendMessage(messageRequest: CommentModel, onSuccess: @escaping (CommentModel) -> Void, onError: @escaping (QError) -> Void) {
    QiscusCore.shared.sendMessage(message: messageRequest, onSuccess: onSuccess, onError: onError)
  }
  
  func uploadFileupload(
    file : FileUploadModel,
    onSuccess: @escaping (FileModel) -> Void,
    onError: @escaping (QError) -> Void,
    progress: @escaping (Double) -> Void
  ) {
    QiscusCore.shared.upload(file: file, onSuccess: onSuccess, onError: onError, progressListener: progress)
  }
  
  // event
  
  func markAsRead(roomId: String, messageId: String) {
    QiscusCore.shared.markAsRead(roomId: roomId, commentId: messageId)
  }
  
  func connectToQiscus(delegate: QiscusConnectionDelegate) {
    if QiscusCore.hasSetupUser() {
      _ = QiscusCore.connect(delegate: delegate)
    }
  }
  func subscribeChatRooms(delegate: QiscusCoreDelegate) {
    if QiscusCore.hasSetupUser() {
      QiscusCore.delegate = delegate
    }
  }
  
  func unSubcribeChatRooms() {
    if QiscusCore.hasSetupUser() {
      QiscusCore.delegate = nil
    }
  }
  
  func subscribeChatRoom(delegate: QiscusCoreRoomDelegate, roomId: String) {
    if QiscusCore.hasSetupUser() {
      if let roomModel = self.getDataBase()?.room.find(id: roomId) {
        roomModel.delegate = delegate
        QiscusCore.shared.subscribeChatRoom(roomModel)
      }
    }
  }
  
  func unSubcribeChatRoom(roomId: String) {
    if QiscusCore.hasSetupUser() {
      if let roomModel = self.getDataBase()?.room.find(id: roomId) {
        roomModel.delegate = nil
        QiscusCore.shared.unSubcribeChatRoom(roomModel)
      }
    }
  }
  
}
