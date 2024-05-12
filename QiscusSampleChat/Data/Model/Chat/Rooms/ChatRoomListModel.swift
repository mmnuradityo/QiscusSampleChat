//
//  ChatRoomListModel.swift
//  QiscusSampleChat
//
//  Created by Admin on 04/05/24.
//

import Foundation

struct ChatRoomListModel {
  
  var currentPage : Int = 0
  var listRooms: [ChatRoomModel] = []
  
  init(currentPage: Int? = nil, rooms: [ChatRoomModel]) {
    self.currentPage = currentPage ?? 1
    self.listRooms = rooms
  }
 
}

// MARK: ~ handle Action
extension ChatRoomListModel {
  
  mutating func configureWithNewData(chatRoomList: ChatRoomListModel) -> [Int] {
    if self.currentPage < chatRoomList.currentPage {
      self.currentPage = chatRoomList.currentPage
    }
    return appendOrUpdate(rooms: chatRoomList.listRooms)
  }
  
  mutating func appendOrUpdate(rooms: [ChatRoomModel]) -> [Int] {
    for room in rooms {
      if let index = self.listRooms.firstIndex(where: { $0.id == room.id }) {
        self.listRooms[index] = room
      } else {
        self.listRooms.insert(room, at: 0)
      }
    }
    
    return sortingListRooms()
  }
  
  mutating func appendOrUpdate(room: ChatRoomModel) -> [Int] {
    if let index = self.listRooms.firstIndex(where: { $0.id == room.id }) {
      self.listRooms[index] = room
    } else {
      self.listRooms.insert(room, at: 0)
    }
    return sortingListRooms()
  }
  
  mutating func updateLastMessage(message: MessageModel) -> [Int]? {
    if let index = self.listRooms.firstIndex(where: { $0.id == message.roomId }) {
      self.listRooms[index].lastMessage = message
      return sortingListRooms()
    }
    return nil
  }
  
  mutating func sortingListRooms() -> [Int] {
    let listRooms = self.listRooms
    self.listRooms = self.listRooms.sorted { lhs, rhs in
      guard let timeStampLhs = lhs.lastMessage?.timeStamp,
            let timeStampRhs = rhs.lastMessage?.timeStamp
      else {
        return false
      }
      
      return timeStampLhs > timeStampRhs
    }
    
    var indexs: [Int] = []
    for (itemIndex, item) in listRooms.enumerated() {
      if let newIndex = self.listRooms.firstIndex(where: {
        $0.id == item.id || $0.lastMessage?.id == item.lastMessage?.id
      }) {
        if newIndex != itemIndex {
          indexs.append(newIndex)
        } else {
          indexs.append(itemIndex)
        }
      }
    }
    return indexs
  }
  
}
