//
//  MessageRequest.swift
//  QiscusSampleChat
//
//  Created by Admin on 29/04/24.
//

import QiscusCore

struct MessageRequest {
  
  let roomId: String
  let message: String
  let type: MessageType
  let extras: [String: Any]?
  var payload: [String: Any]?
  var fileRequest: MessageFileRequest?
  
  init(roomId: String, message: String, type: MessageType, extras: [String : Any]? = nil) {
    self.roomId = roomId
    self.message = message
    self.type = type
    self.extras = extras
  }
  
  mutating func with(fileRequest file: MessageFileRequest) {
    self.fileRequest = file
  }
  
  mutating func createPayload(fileModel: FileModel) {
    self.payload = [
      MessageDataParams.fileName.rawValue: fileModel.name,
      MessageDataParams.url.rawValue: fileModel.url.absoluteString,
      MessageDataParams.caption.rawValue: self.fileRequest?.caption ?? ""
    ]
  }
}

// MARK: ~ handle MessageRequest to CommnetModel
extension MessageRequest {
  
  func toComment() -> CommentModel {
    let comment = CommentModel()
    comment.roomId = roomId
    comment.message = message
    comment.type = type.toString()
    comment.extras = extras
    comment.payload = payload
    return comment
  }
  
  func toFileUpload() -> FileUploadModel? {
    guard let file = self.fileRequest else {
      return nil
    }
    let fileUpload = FileUploadModel()
    fileUpload.data = file.data
    fileUpload.name = file.name
    fileUpload.caption = file.caption
    return fileUpload
  }
  
  func getPayload() -> [String: Any]? {
    guard let paylod = fileRequest else { return nil }
    return [
      MessageDataParams.fileName.rawValue: paylod.name,
      MessageDataParams.url.rawValue: paylod.url!.absoluteString,
      MessageDataParams.caption.rawValue: paylod.caption
    ]
  }
}
