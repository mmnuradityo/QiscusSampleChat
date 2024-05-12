//
//  MessageModelMapper.swift
//  QiscusSampleChat
//
//  Created by Admin on 09/05/24.
//

import QiscusCore

// MARK: - comment to message mapper
extension CommentModel {
  
  func toMessage() -> MessageModel {
    return toMessage(withPayload: self.payload)
  }
  
  func toMessage(withPayload: [String: Any]?) -> MessageModel {
    let dateTime = DateTimes.timeFormatter.date(from: self.timestamp)
    return MessageModel(
      id: self.id,
      roomId: self.roomId,
      timeString: DateTimes.timeStampFormat(dateTime),
      dateTime: DateTimes.dateFormatter(self.date),
      timeStamp: dateTime,
      status: self.status,
      chatFrom: generateChatFrom(),
      data: createData(withPayload: withPayload),
      sender: createSender()
    )
  }
  
  private func generateChatFrom() -> MessageModel.ChatFrom {
    if AppConfiguration.isMyMessage(senderEmail: self.userEmail) {
      return .me
    } else {
      return .other
    }
  }
  
  private func createData(withPayload: [String: Any]?) -> MessageDataModel {
    let dataType = generateType()
    
    if dataType != .text && dataType != .unknown && withPayload != nil {
      let fileName = withPayload![MessageDataParams.fileName.rawValue] as? String ?? ""
      let caption = withPayload![MessageDataParams.caption.rawValue] as? String ?? ""
      let rawFileUrl = withPayload![MessageDataParams.url.rawValue] as? String ?? ""
      let fileLocalUrl: URL? =  FileUtils.fileExistsWithURL(
        fileNameWithExtension: FileUtils.fileName(from: rawFileUrl)
      )
      
      let fileUrl: String
      let isDownloaded: Bool
      var extras = [String: Any]()
      
      if fileLocalUrl == nil {
        isDownloaded = false
        fileUrl = rawFileUrl
      } else {
        isDownloaded = true
        fileUrl = fileLocalUrl!.absoluteString
        
        if dataType == .file {
          extras[MessageDataExtraParams.extention.rawValue] = FileUtils.fileExtension(from: rawFileUrl)
          extras[MessageDataExtraParams.size.rawValue] = FileUtils.getFileSize(atPath: fileLocalUrl!.path)
        }
      }
      
      return MessageDataModel(
        dataType: dataType, fileName: fileName, url: fileUrl,
        caption: caption, isDownloaded: isDownloaded, extras: extras
      )
    } else {
      return MessageDataModel(
        dataType: dataType, fileName: "", url: "", caption: self.message
      )
    }
  }
  
  private func createSender() -> MessageSenderModel {
    return MessageSenderModel(
      id: self.userId,
      name: self.username,
      email: self.userEmail,
      avatarImage: ImageModel(url: self.userAvatarUrl)
    )
  }
  
  private func generateType() -> MessageType {
    switch self.type {
    case "text":
      return .text
    case "file_attachment":
      guard let payload = self.payload, let url = payload["url"] as? String else {
        return .unknown
      }
      return FileUtils.generateType(from: url)
    default:
      return .unknown
    }
  }
  
}
