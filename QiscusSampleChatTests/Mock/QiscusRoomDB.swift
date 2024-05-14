//
//  QiscusRoomDB.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 13/05/24.
//

import Foundation
@testable import QiscusCore

class MockRoomDB: RoomDB {
  
  var room: RoomModel?
  
  override func find(id: String) -> RoomModel? {
    return room
  }
  
  
}

class MockCommentDB: CommentDB {
  
  var comment: CommentModel?
  var comments: [CommentModel]?
  
  override func find(id: String) -> CommentModel? {
    return comment
  }
 
  override func find(roomId id: String) -> [CommentModel]? {
    return comments
  }
}
