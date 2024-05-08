//
//  MessageModel.swift
//  QiscusSampleChat
//
//  Created by Admin on 26/04/24.
//

import QiscusCore

struct MessageModel {
  
  let id: String
  let roomId: String
  let time: String
  let dateString: String
  var status: CommentStatus
  let chatFrom: ChatFrom
  var data: MessageDataModel
  var sender: MessageSenderModel
  var isShowDate: Bool
  var isFirst: Bool
  
  init(
    id: String,
    roomId: String,
    time: String,
    dateTime: String,
    status: CommentStatus,
    chatFrom: ChatFrom,
    data: MessageDataModel,
    sender: MessageSenderModel,
    isDateShow: Bool = false,
    isFirst: Bool = false
  ) {
    self.id = id
    self.roomId = roomId
    self.time = time
    self.dateString = dateTime
    self.status = status
    self.chatFrom = chatFrom
    self.data = data
    self.sender = sender
    self.isShowDate = isDateShow
    self.isFirst = isFirst
  }
  
  enum ChatFrom {
    case me
    case other
  }
  
}

// MARK: - comment to message mapper
extension CommentModel {
  func toMessage() -> MessageModel {
    return toMessage(withPayload: self.payload)
  }
  
  func toMessage(withPayload: [String: Any]?) -> MessageModel {
    return MessageModel(
      id: self.id,
      roomId: self.roomId,
      time: timeStampFormat(self.timestamp),
      dateTime: dateFormatter(self.date),
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
      
      var fileUrl = FileUtils.fileExistsWithURL(
        fileNameWithExtension: FileUtils.fileName(from: rawFileUrl)
      )?.absoluteString ?? ""
      var isDownloaded = true
      
      if fileUrl.isEmpty {
        isDownloaded = false
        fileUrl = rawFileUrl
      }
      
      return MessageDataModel(
        dataType: dataType, fileName: fileName, url: fileUrl, caption: caption, isDownloaded: isDownloaded
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

let timeFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.timeZone = TimeZone(abbreviation: "UTC")
  formatter.locale = Locale(identifier: "en_US_POSIX")
  formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
  return formatter
}()

let timeStampFormat: (String) -> String = { dateStringer in
  let formatter = DateFormatter()
  formatter.dateFormat = "HH:mm"
  let dateFormater = timeFormatter.date(from: dateStringer)
  return dateFormater != nil ? formatter.string(from: dateFormater!) : "empty"
}

let dateFormatter: (Date) -> String = { date in
  let formatter = DateFormatter()
  formatter.dateFormat = "EEEE, MM dd, yyyy"
  let dateStringer = formatter.string(from: date)
  return dateStringer
}


