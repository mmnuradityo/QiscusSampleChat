//
//  MockRepository.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 24/04/24.
//

import XCTest
@testable import QiscusSampleChat
@testable import QiscusCore

class MockRepository: RepositoryProtocol {
  
  var expectation: XCTestExpectation?
  var methodCalledCount = 0
  var error: Error?
  var isSuccess = false
  
  // user login
  var userActive: UserActive?
  var isErrorLogout = false
  
  func login(userRequest: QiscusSampleChat.UserRequest, onSuccess: @escaping (QiscusSampleChat.UserActive) -> Void, onError: @escaping (QiscusSampleChat.UserError) -> Void) {
    if let error = error, error is UserError {
      onError(error as! UserError)
    } else if let user = userActive {
      onSuccess(user)
    }
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  func getUserActive() -> QiscusSampleChat.UserActive? {
    methodCalledCount += 1
    return userActive
  }
  
  func logout(completion: @escaping () -> Void) {
    if error == nil {
      completion()
    }
    methodCalledCount += 1
    expectation?.fulfill()
    
  }
  
  func registerDeviceToken(onSuccess: @escaping (Bool) -> Void, onError: @escaping (QError) -> Void) {
    // do nothings
  }
  
  // load chatroom
  var chatRoom: ChatRoomModel?
  var imageData: Data?
  var imageState: ImageModel.State = .new
  
  func loadRoomWithMessage(roomId: String, onSuccess: @escaping (QiscusSampleChat.ChatRoomModel) -> Void, onError: @escaping (QiscusSampleChat.ChatError) -> Void) {
    if let error = error, error is ChatError {
      onError(error as! ChatError)
    } else if let chatRoom = chatRoom {
      onSuccess(chatRoom)
    }
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  func loadMoreMessages(
    roomId: String, lastMessageId: String, limit: Int,
    onSuccess: @escaping ([QiscusSampleChat.MessageModel]) -> Void,
    onError: @escaping (QiscusSampleChat.ChatError) -> Void
  ) {
    if let error = error, error is ChatError {
      onError(error as! ChatError)
    } else if let chatRoom = chatRoom, !chatRoom.listMessages.isEmpty {
      onSuccess(chatRoom.listMessages)
    }
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  func loadThumbnailImage(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void) {
    completion(imageData, imageState)
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  func loadThumbnailImage(message: MessageModel, completion: @escaping (MessageModel) -> Void) {
    var message = message
    message.data.previewImage = ImageModel(url: URL(string: ""), data: imageData, state: imageState)
    completion(message)
    
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  func loadThumbnailVideo(message: MessageModel, completion: @escaping (MessageModel) -> Void) {
    var message = message
    message.data.previewImage = ImageModel(url: URL(string: ""), data: imageData, state: imageState)
    completion(message)
    
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  // send message
  var message: MessageModel?
  var progresPercent: Double = 0.0
  var isUploadFileupload = false
  var chatRoomList: ChatRoomListModel?
  
  func sendMessage(
    messageRequest: MessageRequest,
    onSuccess: @escaping (MessageModel) -> Void,
    onError: @escaping (ChatError) -> Void
  ) {
    if let error = error, error is ChatError {
      onError(error as! ChatError)
    } else if let message = message {
      var messageResponse = message
      messageResponse.status = .sent
      onSuccess(messageResponse)
    }
    
    if !isUploadFileupload {
      methodCalledCount += 1
      expectation?.fulfill()
    }
  }
  
  func sendMessageFile(
    messageRequest: QiscusSampleChat.MessageRequest,
    onSuccess: @escaping (QiscusSampleChat.MessageModel) -> Void,
    onError: @escaping (QiscusSampleChat.ChatError) -> Void,
    progress: @escaping (Double) -> Void
  ) {
    isUploadFileupload = true
    
    if let error = error, error is ChatError {
      onError(error as! ChatError)
    } else if let message = message {
      var messageResponse = message
      messageResponse.status = .sent
      onSuccess(messageResponse)
    } else {
      progress(progresPercent)
    }
    
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  func getQiscusDataBase() -> QiscusDatabaseManager? {
    // TODO:
    return nil
  }
  
  func connectToQiscus(delegate: any QiscusConnectionDelegate) {
    // TODO:
  }
  
  func subscribeChatRoom(delegate: any QiscusCoreRoomDelegate, roomId: String) {
    // TODO:
  }
  
  func unSubcribeChatRoom(roomId: String) {
    // TODO:
  }
  
  func loadRooms(page: Int, limit: Int, onSuccess: @escaping (ChatRoomListModel) -> Void, onError: @escaping (ChatError) -> Void) {
    if let error = error {
      onError(ChatError.custom(message: error.localizedDescription))
    } else if let chatRoomList = chatRoomList {
      onSuccess(chatRoomList)
    }
    
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  func downloadFile(message: MessageModel, onSuccess: @escaping (MessageModel) -> Void, onProgress: @escaping (Float) -> Void, onError: @escaping (ChatError) -> Void) {
    if let error = error {
      onError(ChatError.custom(message: error.localizedDescription))
    } else {
      if progresPercent > 0.0 {
        onProgress(Float(progresPercent))
      }
      var message = message
      message.data.isDownloaded = true
      onSuccess(message)
    }
    
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  // event
  
  func subscribeChatRooms(delegate: QiscusCoreDelegate) {
    // do nothings
  }
  
  func unSubcribeChatRooms() {
    // do nothings
  }
  
  func markAsRead(roomId: String, messageId: String) {
    // do nothings
  }
}
