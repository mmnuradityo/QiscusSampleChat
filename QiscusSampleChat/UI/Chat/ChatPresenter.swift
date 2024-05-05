//
//  ChatPresenter.swift
//  QiscusSampleChat
//
//  Created by Admin on 27/04/24.
//

import Foundation
import QiscusCore

protocol ChatPresenterProtocol {
  func loadRoomWithMessage(roomId: String)
  func loadMoreMessages(roomId: String, lastMessageId: String)
  func loadThumbnailImage(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void)
  func loadThumbnailVideo(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void)
  func sendMessage(messageRequest: MessageRequest)
  func sendMessageFile(messageRequest: MessageRequest)
  func logout()
}

class ChatPresenter: ChatPresenterProtocol {
  
  let repository: RepositoryProtocol
  let delegate: ChatDelete
  
  init(repository: RepositoryProtocol, delegate: ChatDelete) {
    self.repository = repository
    self.delegate = delegate
  }
  
  func loadRoomWithMessage(roomId: String) {
    delegate.onLoading(isLoading: true)
    
    repository.loadRoomWithMessgae(roomId: roomId) { chatRoom in
      self.delegate.onLoading(isLoading: false)
      self.delegate.onRoomWithMessage(chatRoomModel: chatRoom)
    } onError: { error in
      self.delegate.onLoading(isLoading: false)
      self.delegate.onError(error: error)
    }
  }
  
  func loadMoreMessages(roomId: String, lastMessageId: String) {
    delegate.onLoading(isLoading: true)
    repository.loadMoreMessages(roomId: roomId, lastMessageId: lastMessageId, limit: 25) { messages in
      self.delegate.onLoading(isLoading: false)
      self.delegate.onMessages(messageModels: messages)
    } onError: { error in
      self.delegate.onLoading(isLoading: false)
    }
  }
  
  func loadThumbnailImage(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void) {
    repository.loadThumbnailImage(url: url, completion: completion)
  }
  
  func loadThumbnailVideo(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void) {
    repository.loadThumbnailVideo(url: url, completion: completion)
  }
  
  func sendMessage(messageRequest: MessageRequest) {
    let comment = messageRequest.toComment()
    var messageFromComment = comment.toMessage()
    delegate.onSendMessage(messageModel: messageFromComment)
    
    repository.sendMessage(messageRequest: messageRequest) { message in
      self.delegate.onSendMessage(messageModel: message)
    } onError: { error in
      messageFromComment.status = .failed
      self.delegate.onSendMessage(messageModel: messageFromComment)
    }
  }
  
  func sendMessageFile(messageRequest: MessageRequest) {
    let comment = messageRequest.toComment()
    comment.payload = messageRequest.getPayload()
    var messageFromComment = comment.toMessage()
    
    delegate.onSendMessage(messageModel: messageFromComment)
    
    repository.sendMessageFile(messageRequest: messageRequest) { message in
      self.delegate.onSendMessage(messageModel: message)
    } onError: { error in
      messageFromComment.status = .failed
      self.delegate.onSendMessage(messageModel: messageFromComment)
    } progress: { percent in
      self.delegate.onProgressUploadFIle(percent: percent)
    }
  }
  
  func logout() {
    repository.logout {
      self.delegate.onLogout()
    }
  }
  
  protocol ChatDelete {
    func onLoading(isLoading: Bool)
    func onRoomWithMessage(chatRoomModel: ChatRoomModel)
    func onMessages(messageModels: [MessageModel])
    func onSendMessage(messageModel: MessageModel)
    func onRoomEvent(chatRoomModel: ChatRoomModel)
    func onMessageEvent(messageModel: MessageModel)
    func onProgressUploadFIle(percent: Double)
    func onError(error: ChatError)
    func onLogout()
  }
}

extension ChatPresenter: ChatEventObserver {
  
  func onEventRoom(room: ChatRoomModel) {
    delegate.onRoomEvent(chatRoomModel: room)
  }
  
  func onEventMessage(message: MessageModel) {
    delegate.onMessageEvent(messageModel: message)
  }
  
}
