//
//  Repository.swift
//  QiscusSampleChat
//
//  Created by Admin on 23/04/24.
//

import QiscusCore
import AVFoundation

protocol RepositoryProtocol {
  // login
  func login(userRequest: UserRequest, onSuccess: @escaping (UserActive) -> Void, onError: @escaping (UserError) -> Void)
  func getUserActive() -> UserActive?
  func logout(completion: @escaping () -> Void)
  func registerDeviceToken(onSuccess: @escaping (Bool) -> Void, onError: @escaping (QError) -> Void)
  
  // load messages
  func getQiscusDataBase() -> QiscusDatabaseManager?
  func loadRoomWithMessage(roomId: String, onSuccess: @escaping (ChatRoomModel) -> Void, onError: @escaping (ChatError) -> Void)
  func loadMoreMessages(roomId: String, lastMessageId: String, limit: Int, onSuccess: @escaping ([MessageModel]) -> Void, onError: @escaping (ChatError) -> Void)
  func loadThumbnailImage(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void)
  func loadThumbnailImage(message: MessageModel, completion: @escaping (MessageModel) -> Void)
  func loadThumbnailVideo(message: MessageModel, completion: @escaping (MessageModel) -> Void)
  func downloadFile(message: MessageModel, onSuccess: @escaping (MessageModel) -> Void, onProgress: @escaping (Float) -> Void, onError: @escaping (ChatError) -> Void)
  
  // load rooms
  func loadRooms(page: Int, limit: Int, onSuccess: @escaping (ChatRoomListModel) -> Void, onError: @escaping (ChatError) -> Void)
  
  // sending
  func sendMessage(messageRequest: MessageRequest, onSuccess: @escaping (MessageModel) -> Void, onError: @escaping (ChatError) -> Void)
  func sendMessageFile(messageRequest : MessageRequest, onSuccess: @escaping (MessageModel) -> Void, onError: @escaping (ChatError) -> Void, progress: @escaping (Double) -> Void)
  
  // event
  func markAsRead(roomId: String, messageId: String)
  func connectToQiscus(delegate: QiscusConnectionDelegate)
  func subscribeChatRooms(delegate: QiscusCoreDelegate)
  func unSubcribeChatRooms()
  func subscribeChatRoom(delegate: QiscusCoreRoomDelegate, roomId: String)
  func unSubcribeChatRoom(roomId: String)
}

class Repository: RepositoryProtocol {
  
  let dataStore: DataStoreProtocol
  let imageManager: ThumbnailManagerProtocol
  let qiscusManager: QiscusManagerProtocol
  let globalDispatchQueue: DispatchQueue
  let fileUtils: FileUtilsManagementProtocol.Type
  
  init(
    dataStore: DataStoreProtocol,
    imageManager: ThumbnailManagerProtocol,
    qiscusManager: QiscusManagerProtocol,
    dispatchQueue: DispatchQueue = DispatchQueue.global(qos: .background),
    fileUtils: FileUtilsManagementProtocol.Type = FileUtils.self
  ) {
    self.dataStore = dataStore
    self.imageManager = imageManager
    self.qiscusManager = qiscusManager
    self.globalDispatchQueue = dispatchQueue
    self.fileUtils = fileUtils
  }
  
  func login(
    userRequest: UserRequest,
    onSuccess: @escaping (UserActive) -> Void,
    onError: @escaping (UserError) -> Void
  ) {
    qiscusManager.login(userRequest: userRequest) { userModel in
      let userActive = userModel.toUserActive()
      let isSaved = self.dataStore.getUserLocalDateBase().saveUser(user: userActive)
      
      if isSaved {
        self.dataStore.getUserLocalDateBase().saveToken(token: userModel.token)
        onSuccess(userActive)
      } else {
        onError(UserError.invalidSaveUser)
      }
      
    } onError: { qiscusError in
      onError(UserError.custom(message: qiscusError.message))
    }
  }
  
  func getUserActive() -> UserActive? {
    return dataStore.getUserLocalDateBase().getUser()
  }
  
  func logout(completion: @escaping () -> Void) {
    if dataStore.getUserLocalDateBase().getUser() != nil {
      qiscusManager.logout {
        if self.dataStore.getUserLocalDateBase().clearUser() != nil {
          completion()
        }
      }
    }
  }
  
  func registerDeviceToken(onSuccess: @escaping (Bool) -> Void, onError: @escaping (QError) -> Void) {
    let deviceToken = dataStore.getUserLocalDateBase().getToken()
    if !deviceToken.isEmpty {
      qiscusManager.registerDeviceToken(
        deviceToken: deviceToken, onSuccess: onSuccess, onError: onError
      )
    }
  }
  
  func getQiscusDataBase() -> QiscusDatabaseManager? {
    return qiscusManager.getDataBase()
  }
  
  func loadRoomWithMessage(roomId: String, onSuccess: @escaping (ChatRoomModel) -> Void, onError: @escaping (ChatError) -> Void) {
    globalDispatchQueue.async {
      let localRoomModel = self.qiscusManager.getDataBase()?.room.find(id: roomId)
      if localRoomModel != nil {
        self.onSuccessRoomWithMessage(
          localRoomModel!, comments: self.qiscusManager.getDataBase()?.comment.find(roomId: roomId), onSuccess: onSuccess
        )
      }
      
      self.qiscusManager.loadRoomWithMessage(roomId: roomId) { roomModel, comments in
        self.qiscusManager.getDataBase()?.comment.save(comments)
        self.onSuccessRoomWithMessage(
          roomModel, comments: comments, onSuccess: onSuccess
        )
      } onError: { qiscusError in
        onError(ChatError.custom(message: qiscusError.message))
      }
    }
  }
  
  private func onSuccessRoomWithMessage(
    _ roomModel: RoomModel, comments: [CommentModel]?, onSuccess: @escaping (ChatRoomModel) -> Void
  ) {
    var chatRoom = roomModel.toChatRoom()
    _ = chatRoom.appendBefore(getCommentToMessages(comments))
    
    DispatchQueue.main.async {
      onSuccess(chatRoom)
    }
  }
  
  private func getCommentToMessages(_ comments: [CommentModel]?) -> [MessageModel] {
    var messages: [MessageModel] = []
    comments?.forEach { comment in
      messages.append(comment.toMessage())
    }
    return messages
  }
  
  func loadMoreMessages(roomId: String, lastMessageId: String, limit: Int, onSuccess: @escaping ([MessageModel]) -> Void, onError: @escaping (ChatError) -> Void) {
    qiscusManager.loadMoreMessages(roomId: roomId, lastMessageId: lastMessageId, limit: limit) { comments in
      self.globalDispatchQueue.async {
        let messages = self.getCommentToMessages(comments)
        
        DispatchQueue.main.async {
          onSuccess(messages)
        }
      }
    } onError: { error in
      onError(ChatError.custom(message: error.message))
    }
  }
  
  func loadThumbnailImage(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void) {
    imageManager.loadThumbnailImage(url: url, completion: completion)
  }
  
  func loadThumbnailImage(message: MessageModel, completion: @escaping (MessageModel) -> Void) {
    let url: URL? = message.data.isDownloaded ? message.data.url : message.data.previewImage.url
    imageManager.loadThumbnailImage(url: url) { imageData, imageState in
      var message = message
      message.data.previewImage = ImageModel(
        url: url, data: imageData, state: imageState
      )
      completion(message)
    }
  }
  
  func loadThumbnailVideo(message: MessageModel, completion: @escaping (MessageModel) -> Void) {
    let url: URL? = message.data.isDownloaded ? message.data.url : message.data.previewImage.url
    imageManager.loadThumbnailVideo(url: url) { imageData, durtion, imageState in
      var message = message
      message.data.previewImage = ImageModel(
        url: url, data: imageData, state: imageState
      )
      message.data.extras[MessageDataExtraParams.duration.rawValue] =
      durtion != nil ? self.videoTimeString(from: durtion!) : "00:00"
      completion(message)
    }
  }
  
  private func videoTimeString(from time: CMTime) -> String {
    let totalSeconds = CMTimeGetSeconds(time)
    let minutes = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
    let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
    
    return  String(format: "%02d:%02d", minutes, seconds)
  }
  
  func loadRooms(page: Int, limit: Int, onSuccess: @escaping (ChatRoomListModel) -> Void, onError: @escaping (ChatError) -> Void) {
    qiscusManager.loadRooms(page: page, limit: limit) { rooms, meta in
      var chatRoomModels: [ChatRoomModel] = []
      rooms.forEach { room in
        chatRoomModels.append(room.toChatRoom())
      }
      onSuccess(ChatRoomListModel(currentPage: meta?.currentPage, rooms: chatRoomModels))
    } onError: { error in
      onError(ChatError.custom(message: error.message))
    }
  }
  
  func sendMessage(messageRequest: MessageRequest, onSuccess: @escaping (MessageModel) -> Void, onError: @escaping (ChatError) -> Void) {
    let request = messageRequest.toComment()
    
    qiscusManager.sendMessage(messageRequest: request) { comment in
      let message = comment.toMessage()
      onSuccess(message)
    } onError: { error in
      onError(ChatError.custom(message: error.message))
    }
  }
  
  func sendMessageFile(
    messageRequest : MessageRequest,
    onSuccess: @escaping (MessageModel) -> Void,
    onError: @escaping (ChatError) -> Void,
    progress: @escaping (Double) -> Void
  ) {
    guard let fileRequest = messageRequest.toFileUpload() else {
      onError(ChatError.invalidEmptyUploadFile)
      return
    }
    
    qiscusManager.uploadFileupload(file: fileRequest) { fileModel in
      self.saveFileIfNeeded(fileUrl: fileModel.url, onError: onError)
      
      var request = messageRequest
      request.createPayload(fileModel: fileModel)
      
      self.sendMessage(
        messageRequest: request, onSuccess: onSuccess, onError: onError
      )
    } onError: { error in
      onError(ChatError.custom(message: error.message))
    } progress: { percent in
      progress(percent)
    }
  }
  
  func downloadFile(
    message: MessageModel,
    onSuccess: @escaping (MessageModel) -> Void,
    onProgress: @escaping (Float) -> Void,
    onError: @escaping (ChatError) -> Void
  ) {
    guard let url = message.data.url else {
      onError(ChatError.custom(message: "url is empty"))
      return
    }
    qiscusManager.downloadFile(url: url, onSuccess: { url in
      self.saveFileIfNeeded(fileUrl: url, onError: onError)
      var messageResult = message
      messageResult.data.url = url
      messageResult.data.isDownloaded = true
      onSuccess(messageResult)
    }, onProgress: onProgress)
  }
  
  private func saveFileIfNeeded(fileUrl: URL?, onError: @escaping (ChatError) -> Void) {
    guard let fileUrl = fileUrl,
          fileUtils.fileExistsWithURL(fileNameWithExtension: fileUrl.lastPathComponent) == nil
    else { return }
    
    fileUtils.save(tempLocalUrl: fileUrl) { url, error in
      if let error = error {
        onError(ChatError.custom(message: error.localizedDescription))
        return
      }
      
      switch self.fileUtils.generateType(from: url!.lastPathComponent) {
      case .image:
        self.fileUtils.saveImageToGallery(imageURL: url!) { error in
          if let error = error {
            onError(ChatError.custom(message: error.localizedDescription))
          }
        }
      case .video:
        self.fileUtils.saveVideoToGallery(
          videoURL: url!, albumName: AppConfiguration.APP_IDENTIFIER
        ) { error in
          if let error = error {
            onError(ChatError.custom(message: error.localizedDescription))
          }
        }
      default:
        break
      }
      
    }
  }
  
  func markAsRead(roomId: String, messageId: String) {
    qiscusManager.markAsRead(roomId: roomId, messageId: messageId)
  }
  
  func connectToQiscus(delegate: QiscusConnectionDelegate) {
    qiscusManager.connectToQiscus(delegate: delegate)
  }
  
  func subscribeChatRooms(delegate: QiscusCoreDelegate) {
    qiscusManager.subscribeChatRooms(delegate: delegate)
  }
  
  func unSubcribeChatRooms() {
    qiscusManager.unSubcribeChatRooms()
  }
  
  func subscribeChatRoom(delegate: QiscusCoreRoomDelegate, roomId: String) {
    qiscusManager.subscribeChatRoom(delegate: delegate, roomId: roomId)
  }
  
  func unSubcribeChatRoom(roomId: String) {
    qiscusManager.unSubcribeChatRoom(roomId: roomId)
  }
  
}
