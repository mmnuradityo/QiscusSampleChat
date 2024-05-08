//
//  DataStore.swift
//  QiscusSampleChat
//
//  Created by Admin on 23/04/24.
//

import QiscusCore

protocol QiscusManagerProtocol {
  func setupEngine(appID: String)
  func login(userRequest: UserRequest, onSuccess: @escaping (UserModel) -> Void, onError: @escaping (QError) -> Void)
  func logout(completion: @escaping () -> Void)
  func getDataBase() -> QiscusDatabaseManager?
  func registerDeviceToken(deviceToken: String, onSuccess: @escaping (Bool) -> Void, onError: @escaping (QError) -> Void)
  func loadRoomWithMessage(roomId: String, onSuccess: @escaping (RoomModel, [CommentModel]) -> Void, onError: @escaping (QError) -> Void)
  func loadMoreMessages(roomId: String, lastMessageId: String, limit: Int, onSuccess: @escaping ([CommentModel]) -> Void, onError: @escaping (QError) -> Void)
  func downloadFile(url: URL, onSuccess: @escaping (URL) -> Void, onProgress: @escaping (Float) -> Void)
  func sendMessage(messageRequest: CommentModel, onSuccess: @escaping (CommentModel) -> Void, onError: @escaping (QError) -> Void)
  func uploadFileupload(file: FileUploadModel, onSuccess: @escaping (FileModel) -> Void, onError: @escaping (QError) -> Void, progress: @escaping (Double) -> Void)
  func connectToQiscus(delegate: QiscusConnectionDelegate)
  func loadRooms(page: Int, limit: Int, onSuccess: @escaping ([RoomModel], Meta?) -> Void, onError: @escaping (QError) -> Void)
}

class QiscusManager: QiscusManagerProtocol {
  
  func setupEngine(appID: String) {
    QiscusCore.setup(AppID: appID)
    QiscusCore.enableDebugMode(value: true)
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
  
  func getDataBase() -> QiscusDatabaseManager? {
    return QiscusCore.database
  }
  
  func registerDeviceToken(deviceToken: String, onSuccess: @escaping (Bool) -> Void, onError: @escaping (QError) -> Void) {
    if QiscusCore.hasSetupUser() {
      QiscusCore.shared.registerDeviceToken(token: deviceToken, onSuccess: onSuccess, onError: onError)
    }
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
  
  func connectToQiscus(delegate: QiscusConnectionDelegate) {
    if QiscusCore.hasSetupUser() {
      _ = QiscusCore.connect(delegate: delegate)
    }
  }
  
  func loadRooms(
    page: Int, limit: Int,
    onSuccess: @escaping ([RoomModel],Meta?) -> Void,
    onError: @escaping (QError) -> Void
  ) {
    QiscusCore.shared.getAllChatRooms(page: page, limit: limit, onSuccess: onSuccess, onError: onError)
  }
  
}
