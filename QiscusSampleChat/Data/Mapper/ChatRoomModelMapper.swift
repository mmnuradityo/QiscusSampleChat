//
//  RoomModelMapper.swift
//  QiscusSampleChat
//
//  Created by Admin on 09/05/24.
//

import QiscusCore

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
