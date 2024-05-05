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
  
  mutating func configureWithNewData(chatRoomList: ChatRoomListModel) {
    if self.currentPage < chatRoomList.currentPage {
      self.currentPage = chatRoomList.currentPage
      for room in chatRoomList.listRooms {
        self.listRooms.append(room)
      }
    }
  }
  
}
