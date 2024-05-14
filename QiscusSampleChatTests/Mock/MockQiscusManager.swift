//
//  MockQiscusManager.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 23/04/24.
//

import Foundation
import XCTest
@testable import QiscusSampleChat
@testable import QiscusCore

class MockQiscusManager: QiscusManagerProtocol {
  
  var expectation: XCTestExpectation?
  var methodCalledCount = 0
  var error: QError? = nil
  var isSuccessRegisterDeviceToken = false
  
  func setupEngine(appID: String, enableLogDebug: Bool) {
    // do nothings
  }
  
  // user login
  
  func login(userRequest: UserRequest, onSuccess: @escaping (UserModel) -> Void, onError: @escaping (QError) -> Void) {
    if let error = error {
      onError(error)
    } else {
      onSuccess(UserModel())
    }
    
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  func logout(completion: @escaping () -> Void) {
    if error == nil {
      completion()
    }
    
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  func registerDeviceToken(deviceToken: String, onSuccess: @escaping (Bool) -> Void, onError: @escaping (QError) -> Void) {
    if let error = error {
      onError(error)
    } else {
      onSuccess(isSuccessRegisterDeviceToken)
    }
    
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  // load messgaes
  
  var room: RoomModel? = nil
  var comments: [CommentModel]? = nil
  var databaseManager: QiscusDatabaseManager? = nil
  
  func getDataBase() -> QiscusDatabaseManager? {
    return databaseManager
  }
  
  func loadMoreMessages(
    roomId: String, lastMessageId: String, limit: Int,
    onSuccess: @escaping ([CommentModel]) -> Void,
    onError: @escaping (QError) -> Void
  ) {
    if let error = error {
      onError(error)
    } else if let comments = comments {
      onSuccess(comments)
    }
    
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  func loadRoomWithMessage(roomId: String, onSuccess: @escaping (RoomModel, [CommentModel]) -> Void, onError: @escaping (QError) -> Void) {
    if let error = error {
      onError(error)
    } else if let room = room, let comments = comments {
      onSuccess(room, comments)
    }
    
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  // send Message
  
  var comment: CommentModel?
  var fileModel: FileModel?
  var progresPercent: Double = 0.0
  var isUploadFileupload = false
  
  func sendMessage(messageRequest: CommentModel, onSuccess: @escaping (CommentModel) -> Void, onError: @escaping (QError) -> Void) {
    if let error = error {
      onError(error)
    } else if let comment = comment {
      onSuccess(comment)
    }
    
    if !isUploadFileupload {
      methodCalledCount += 1
      expectation?.fulfill()
    }
  }

  func uploadFileupload(file: FileUploadModel, onSuccess: @escaping (FileModel) -> Void, onError: @escaping (QError) -> Void, progress: @escaping (Double) -> Void) {
    isUploadFileupload = true
    
    if let error = error {
      onError(error)
    } else if let fileModel = fileModel {
      onSuccess(fileModel)
    } else {
      progress(progresPercent)
    }
    
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  // load rooms
  
  var roomWithMeta: ([RoomModel], Meta)?
  var progress: Float?
  var successURL: URL?
  
  func loadRooms(page: Int, limit: Int, onSuccess: @escaping ([RoomModel], Meta?) -> Void, onError: @escaping (QError) -> Void) {
    if let error = error {
      onError(error)
    } else if let roomWithMeta = roomWithMeta {
      onSuccess(roomWithMeta.0, roomWithMeta.1)
    }
    
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  func downloadFile(url: URL, onSuccess: @escaping (URL) -> Void, onProgress: @escaping (Float) -> Void) {
    if let successURL = successURL {
      onSuccess(successURL)
    }
    if let progress = progress {
      onProgress(progress)
    }
    
    methodCalledCount += 1
    expectation?.fulfill()
  }
  
  // event
  
  func markAsRead(roomId: String, messageId: String) {
    // do nothings
  }
  
  func connectToQiscus(delegate: any QiscusConnectionDelegate) {
    // TODO:
  }
  
  func subscribeChatRooms(delegate: QiscusCoreDelegate) {
    // do nothings
  }
  
  func unSubcribeChatRooms() {
    // do nothings
  }
  
  func subscribeChatRoom(delegate: QiscusCoreRoomDelegate, roomId: String) {
    // do nothings
  }
  
  func unSubcribeChatRoom(roomId: String) {
    // do nothings
  }
  
}
