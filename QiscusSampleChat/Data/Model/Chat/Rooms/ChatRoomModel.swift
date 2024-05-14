//
//  ChatRoomModel.swift
//  QiscusSampleChat
//
//  Created by Admin on 27/04/24.
//

import QiscusCore

struct ChatRoomModel {
  
  let id: String
  let name: String
  let avatarUrl: URL?
  let participants: String
  var lastMessage: MessageModel?
  
  var listMessages: [MessageModel] = []
  var unreadCount: Int
  var currentLoadMoreId: String = ""
  
  private var _avatarImage: ImageModel?
  var avatarImage: ImageModel? {
    get {
      if self._avatarImage != nil {
        return self._avatarImage
      } else {
        return ImageModel(url: avatarUrl)
      }
    }
    set {
      if self._avatarImage == nil || self._avatarImage?.state != .success {
        self._avatarImage = newValue
      }
    }
  }
  
  init(id: String, name: String, avatarUrl: URL?, participants: String, lastMessage: MessageModel?, unreadCount: Int = 0) {
    self.id = id
    self.name = name
    self.avatarUrl = avatarUrl
    self.participants = participants
    self.lastMessage = lastMessage
    self.unreadCount = unreadCount
  }
  
}

// MARK: ~ handle Action
extension ChatRoomModel {
  
  mutating func appendBefore(_ messages: [MessageModel]?) -> [Int]?  {
    guard let messages = messages else { return nil }
    var cellIndexs: [String] = []
    messages.forEach { message in
      _ = insertOrUpdate(message)
      cellIndexs.append(message.id)
    }
    return sortingListMessages(cellIndexs: cellIndexs)
  }
  
  mutating func appendOrUpdate(_ message: MessageModel) -> Int {
    var currentMessage: MessageModel = message
    var nextMessage: MessageModel
    var index = listMessages.firstIndex(where: { $0.id == currentMessage.id }) ?? -1
    let nexIndex: Int = index + 1
    
    if listMessages.count > nexIndex {
      nextMessage = listMessages[nexIndex]
      if nextMessage.id.contains("ios_") {
        self.listMessages.remove(at: nexIndex)
      }
         
      currentMessage = updateDate(
        currentMessage: currentMessage, nextMessage: nextMessage
      )
    }
    
    index = insertOrUpdate(currentMessage)
    if index == 0 {
      lastMessage = currentMessage
    }
    return index
  }
  
  mutating func insertOrUpdate(_ message: MessageModel) -> Int {
    if let index = self.listMessages.firstIndex(where: { $0.id == message.id }) {
      self.listMessages[index] = message
      return index
    } else {
      self.listMessages.insert(message, at: 0)
      return 0
    }
  }
  
  func updateDate(currentMessage: MessageModel, nextMessage: MessageModel) -> MessageModel {
    var currentMessage = currentMessage
    currentMessage.isShowDate = currentMessage.dateString != nextMessage.dateString
    currentMessage.isFirst = currentMessage.chatFrom != nextMessage.chatFrom
    return currentMessage
  }
  
  mutating func sortingListMessages(cellIndexs: [String]) -> [Int] {
    let posibleMaxIndex = self.listMessages.count - 1
    if posibleMaxIndex == -1 { return [] }
    
    self.listMessages.sort { lhs, rhs in
      guard let timeStampLhs = lhs.timeStamp,
            let timeStampRhs = rhs.timeStamp
      else {
        return false
      }
      
      return timeStampLhs > timeStampRhs
    }
    var currentMessage: MessageModel
    var nextIndex: Int
    var indexPaths: [Int] = []
    
    for index in 0...posibleMaxIndex {
      currentMessage = self.listMessages[index]
      nextIndex = index + 1
      
      if cellIndexs.contains(currentMessage.id) {
        if index == posibleMaxIndex {
          currentMessage.isFirst = true
          currentMessage.isShowDate = true
          self.listMessages[index] = currentMessage
          
        } else if nextIndex < posibleMaxIndex {
          self.listMessages[index] = updateDate(
            currentMessage: currentMessage, nextMessage: self.listMessages[nextIndex]
          )
        }
        
        indexPaths.append(index)
      }
    }
    
    return indexPaths
  }
  
//  mutating func appendBeforeX(_ messages: [MessageModel]?) -> [Int]?  {
//    guard let messages = messages else { return nil }
//    var cellIndexs: [String] = []
//    messages.forEach { message in
//      if let index = self.listMessages.firstIndex(where: { $0.id == message.id }) {
//        self.listMessages[index] = message
//        cellIndexs.append(message.id)
//      } else {
//        self.listMessages.insert(message, at: 0)
//        cellIndexs.append(message.id)
//      }
//    }
//    
//    self.listMessages.sort { lhs, rhs in
//      guard let timeStampLhs = lhs.timeStamp,
//            let timeStampRhs = rhs.timeStamp
//      else {
//        return false
//      }
//      
//      return timeStampLhs > timeStampRhs
//    }
//    
//    let posibleMaxIndex = self.listMessages.count - 1
//    var currentMessage: MessageModel
//    var nextIndex: Int
//    var indexPaths: [Int] = []
//    
//    for index in 0...posibleMaxIndex {
//      currentMessage = self.listMessages[index]
//      nextIndex = index + 1
//      
//      if cellIndexs.contains(currentMessage.id) {
//        if index == posibleMaxIndex {
//          currentMessage.isFirst = true
//          currentMessage.isShowDate = true
//          self.listMessages[index] = currentMessage
//          
//        } else if nextIndex < posibleMaxIndex {
//          self.listMessages[index] = updateDate(
//            currentMessage: currentMessage, nextMessage: self.listMessages[nextIndex]
//          )
//        }
//        
//        indexPaths.append(index)
//      }
//    }
//    
//    return indexPaths
//  }
  
}
