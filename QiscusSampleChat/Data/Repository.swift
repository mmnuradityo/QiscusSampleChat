//
//  Repository.swift
//  QiscusSampleChat
//
//  Created by Admin on 23/04/24.
//

import QiscusCore

protocol RepositoryProtocol {
  // login
  func login(userRequest: UserRequest, onSuccess: @escaping (UserActive) -> Void, onError: @escaping (UserError) -> Void)
  func getUserActive() -> UserActive?
  func logout(completion: @escaping () -> Void)
  
  // load messages
  func getQiscusDataBase() -> QiscusDatabaseManager?
  func loadRoomWithMessgae(roomId: String, onSuccess: @escaping (ChatRoomModel) -> Void, onError: @escaping (ChatError) -> Void)
  func loadMoreMessages(roomId: String, lastMessageId: String, limit: Int, onSuccess: @escaping ([MessageModel]) -> Void, onError: @escaping (ChatError) -> Void)
  func loadThumbnailImage(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void)
  func loadThumbnailVideo(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void)
  func downloadFile(message: MessageModel, onSuccess: @escaping (MessageModel) -> Void, onProgress: @escaping (Float) -> Void, onError: @escaping (ChatError) -> Void)
  
  // sending
  func sendMessage(messageRequest: MessageRequest, onSuccess: @escaping (MessageModel) -> Void, onError: @escaping (ChatError) -> Void)
  func sendMessageFile(messageRequest : MessageRequest, onSuccess: @escaping (MessageModel) -> Void, onError: @escaping (ChatError) -> Void, progress: @escaping (Double) -> Void)
  
  // event
  func connectToQiscus(delegate: QiscusConnectionDelegate)
  func subscribeChatRoom(delegate: QiscusCoreRoomDelegate, roomId: String)
  func unSubcribeChatRoom(roomId: String)
  
  // load rooms
  func loadRooms(page: Int, limit: Int, onSuccess: @escaping (ChatRoomListModel) -> Void, onError: @escaping (ChatError) -> Void)
}

class Repository: RepositoryProtocol {
  
  let dataStore: DataStoreProtocol
  let imageManager: ThumbnailManagerProtocol
  let qiscusManager: QiscusManagerProtocol
  let globalDispatchQueue: DispatchQueue
  
  init(
    dataStore: DataStoreProtocol,
    imageManager: ThumbnailManagerProtocol,
    qiscusManager: QiscusManagerProtocol,
    dispatchQueue: DispatchQueue = DispatchQueue.global(qos: .background)
  ) {
    self.dataStore = dataStore
    self.imageManager = imageManager
    self.qiscusManager = qiscusManager
    self.globalDispatchQueue = dispatchQueue
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
  
  func getQiscusDataBase() -> QiscusDatabaseManager? {
    return qiscusManager.getDataBase()
  }
  
  func registerDeviceToken() {
    let deviceToken = dataStore.getUserLocalDateBase().getToken()
    if !deviceToken.isEmpty {
      qiscusManager.registerDeviceToken(deviceToken: deviceToken) { isSuccess in
        if isSuccess {
          print("success register device token =\(deviceToken)")
        } else {
          print("failed register device token ")
        }
      } onError: {
        print("failed register device token = \($0.message)")
      }
    }
  }
  
  func loadRoomWithMessgae(roomId: String, onSuccess: @escaping (ChatRoomModel) -> Void, onError: @escaping (ChatError) -> Void) {
    globalDispatchQueue.async {
      let localRoomModel = self.qiscusManager.getDataBase()?.room.find(id: roomId)
      if localRoomModel != nil {
        self.onSuccessRoomWithMessage(
          localRoomModel!, comments: self.qiscusManager.getDataBase()?.comment.find(roomId: roomId), onSuccess: onSuccess
        )
      }
      
      self.qiscusManager.loadRoomWithMessage(roomId: roomId) { roomModel, comments in
        self.globalDispatchQueue.async {
          if localRoomModel == nil {
            self.qiscusManager.getDataBase()?.room.save([roomModel])
          }
          //          self.qiscusManager.getDataBase().comment.save(comments)
          self.onSuccessRoomWithMessage(
            roomModel, comments: comments, onSuccess: onSuccess
          )
        }
      } onError: { qiscusError in
        onError(ChatError.custom(message: qiscusError.message))
      }
    }
  }
  
  private func onSuccessRoomWithMessage(
    _ roomModel: RoomModel, comments: [CommentModel]?, onSuccess: @escaping (ChatRoomModel) -> Void
  ) {
    var chatRoom = roomModel.toChatRoom()
    chatRoom.appendBefore(getCommentToMessages(comments))
    
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
  
  func loadThumbnailVideo(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void) {
    imageManager.loadThumbnailVideo(url: url, completion: completion)
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
  
  private func saveFileIfNeeded(fileUrl: URL?, onError: @escaping (ChatError) -> Void) {
    guard let fileUrl = fileUrl,
          FileUtils.fileExistsWithURL(fileNameWithExtension: fileUrl.lastPathComponent) == nil
    else { return }
    
    FileUtils.save(tempLocalUrl: fileUrl) { url, error in
      if let error = error {
        onError(ChatError.custom(message: error.localizedDescription))
        return
      }
      
      switch FileUtils.generateType(from: url!.lastPathComponent) {
      case .image:
        FileUtils.saveImageToGallery(imageURL: url!) { error in
          if let error = error {
            onError(ChatError.custom(message: error.localizedDescription))
          }
        }
      case .video:
        FileUtils.saveVideoToGallery(videoURL: url!) { error in
          if let error = error {
            onError(ChatError.custom(message: error.localizedDescription))
          }
        }
      default:
        break
      }
      
    }
  }
  
  func connectToQiscus(delegate: QiscusConnectionDelegate) {
    qiscusManager.connectToQiscus(delegate: delegate)
  }
  
  func subscribeChatRoom(delegate: QiscusCoreRoomDelegate, roomId: String) {
    if QiscusCore.hasSetupUser() {
      if let roomModel = self.getQiscusDataBase()?.room.find(id: roomId) {
        roomModel.delegate = delegate
//        QiscusCore.shared.subscribeChatRoom(roomModel)
      }
    }
  }
  
  func unSubcribeChatRoom(roomId: String) {
    if QiscusCore.hasSetupUser() {
      if let roomModel = self.getQiscusDataBase()?.room.find(id: roomId) {
        roomModel.delegate = nil
//        QiscusCore.shared.unSubcribeChatRoom(roomModel)
      }
    }
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
  
}
