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
  let lastMessage: MessageModel?
  
  var listMessages: [MessageModel] = []
  var unreadCount: Int
  
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
      self._avatarImage = newValue
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
  
  mutating func appendBefore(_ messages: [MessageModel]?) {
    guard let messages = messages else { return }
    let posibleMaxIndex = messages.count - 1
    var nextIndex = 0
    var currentMessage: MessageModel
    var nextMessage: MessageModel
    
    if posibleMaxIndex == -1 { return }
    
    if listMessages.count > 0 {
      currentMessage = listMessages[listMessages.count - 1]
      nextMessage = messages[0]
    }
    
    for index in 0...posibleMaxIndex {
      nextIndex = index + 1
      currentMessage = messages[index]
      
      if nextIndex <= posibleMaxIndex {
        nextMessage = messages[nextIndex]
        currentMessage = updateDate(
          currentMessage: currentMessage, nextMessage: nextMessage
        )
      } else if index == posibleMaxIndex {
        currentMessage.isShowDate = true
        currentMessage.isFirst = true
        
        let beforeIndex = index - 1
        if beforeIndex >= 0 && listMessages.count - 1 > 0 {
          var beforeMessage = messages[beforeIndex]
          beforeMessage.isShowDate = false
          beforeMessage.isFirst = false
          
          let index = listMessages.firstIndex(
            where: { $0.id == beforeMessage.id }
          ) ?? listMessages.count - 1
          self.listMessages[index] = beforeMessage
        }
      }
      
      _ = insertOrUpdate(currentMessage)
    }
  }
  
  mutating func appendOrUpdate(_ message: MessageModel) -> Int {
    var currentMessage: MessageModel = message
    var nextMessage: MessageModel
    let index = listMessages.firstIndex(where: { $0.id == currentMessage.id }) ?? 0
    
    if listMessages.count > index {
      nextMessage = listMessages[index]
      if nextMessage.id.contains("ios_") {
        self.listMessages.remove(at: index)
      }
         
      currentMessage = updateDate(
        currentMessage: currentMessage, nextMessage: nextMessage
      )
    }
    
    return insertOrUpdate(currentMessage)
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
  
}

// MARK: ~ room to chatRoom mapper
extension RoomModel {
  func toChatRoom() -> ChatRoomModel {
    return ChatRoomModel(
      id: self.id,
      name: self.name,
      avatarUrl: self.avatarUrl,
      participants: generateParticipants(self.participants),
      lastMessage: self.lastComment?.toMessage(),
      unreadCount: self.unreadCount
    )
  }
  
  private func generateParticipants(_ participants: [MemberModel]?) -> String {
    if participants == nil { return "" }
    
    var result = ""
    for (index, member) in participants!.enumerated() {
      if index == 0 {
        result += member.username
      } else {
        result += ", \(member.username)"
      }
    }
    return result
  }
}
