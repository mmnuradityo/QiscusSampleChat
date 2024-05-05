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
    if dataType != .text && withPayload != nil {
      return MessageDataModel(
        dataType: dataType,
        fileName: withPayload![MessageDataParams.fileName.rawValue] as? String ?? "",
        url: withPayload![MessageDataParams.url.rawValue] as? String ?? "",
        caption: withPayload![MessageDataParams.caption.rawValue] as? String ?? ""
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
      
      switch fileExtension(fromURL: url) {
      case "jpg", "png", "heic", "jpeg", "tif", "gif":
        return .image
      case "mp4", "3gp", "mov", "mkv", "webm":
        return .video
      case "doc", "docx", "xls", "xlsx", "ppt", "pptx", "csv", "pdf", 
        "txt", "rtf", "odt", "ods", "odp", "odg", "odf", "odm", "ott":
        return .file
      default:
        return .unknown
      }
    default:
      return .unknown
    }
  }
  
  func fileExtension(fromURL url: String) -> String{
    var ext = ""
    if url.range(of: ".") != nil{
      let fileNameArr = url.split(separator: ".")
      ext = String(fileNameArr.last!).lowercased()
      if ext.contains("?"){
        let newArr = ext.split(separator: "?")
        ext = String(newArr.first!).lowercased()
      }
    }
    return ext
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


