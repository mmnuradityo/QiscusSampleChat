//
//  TableViewCellFactory.swift
//  QiscusSampleChat
//
//  Created by Admin on 25/04/24.
//

import UIKit
import QiscusCore

class ChatTableViewCellFactory: BaseTabelViewCellFactory<MessageModel> {
  
  var delegate: FactoryDelete?
  var uploadelegates: [UploadDelegate] = []
  
  override func registerCells(in tableView: UITableView) {
    super.registerCells(in: tableView)
    
    tableView.register(TextOtherTableViewCell.self, forCellReuseIdentifier: getIndentifier(objectType: TextOtherTableViewCell.self))
    tableView.register(TextMeTableViewCell.self, forCellReuseIdentifier: getIndentifier(objectType: TextMeTableViewCell.self))
    tableView.register(ImageMeTableViewCell.self, forCellReuseIdentifier: getIndentifier(objectType: ImageMeTableViewCell.self))
    tableView.register(ImageOtherTableViewCell.self, forCellReuseIdentifier: getIndentifier(objectType: ImageOtherTableViewCell.self))
    tableView.register(VideoMeTableViewCell.self, forCellReuseIdentifier: getIndentifier(objectType: VideoMeTableViewCell.self))
    tableView.register(VideoOtherTableViewCell.self, forCellReuseIdentifier: getIndentifier(objectType: VideoOtherTableViewCell.self))
    tableView.register(FileMeTableViewCell.self, forCellReuseIdentifier: getIndentifier(objectType: FileMeTableViewCell.self))
    tableView.register(FileOtherTableViewCell.self, forCellReuseIdentifier: getIndentifier(objectType: FileOtherTableViewCell.self))
    tableView.register(NotSupportTableViewCell.self, forCellReuseIdentifier: getIndentifier(objectType: NotSupportTableViewCell.self))
  }
  
  override func create(fromTableView: UITableView, indexPath: IndexPath, data: MessageModel?) -> UITableViewCell {
    guard let message = data else {
      return UITableViewCell()
    }
    
    let identifier: String = generateTableIdentifier(
      dataType: message.data.dataType, from: message.chatFrom
    )
    
    let cell = fromTableView.dequeueReusableCell(
      withIdentifier: identifier, for: indexPath
    ) as UITableViewCell
    
    (cell as? BaseTableViewCellCallerProtocol)?.configure(message: message)
    
    if cell is BaseChatTableViewCell {
      configureAvatar(cell as! BaseChatTableViewCell, message: message, index: indexPath)
    }
    
    if cell is VideoTableViewCell {
      configureVideoMessage(cell as! VideoTableViewCell, message: message, index: indexPath)
      
    } else if cell is ImageTableViewCell {
      configureImageMessage(cell as! ImageTableViewCell, message: message, index: indexPath)
      
    } else if cell is FileTableViewCell {
      (cell as! FileTableViewCell).delegate = self
      configureHandleUploaded(cell: cell as! UploadDelegate, for: message.status)
    }
    
    return cell
  }
  
  func generateTableIdentifier(dataType: MessageType, from: MessageModel.ChatFrom) -> String {
    let identifier: String
    switch dataType {
    case .unknown:
      identifier = getIndentifier(objectType: NotSupportTableViewCell.self)
    case .image:
      identifier = getIndentifier(
        from, bubbleMe: ImageMeTableViewCell.self, bubbleOther: ImageOtherTableViewCell.self
      )
    case .video:
      identifier = getIndentifier(
        from, bubbleMe: VideoMeTableViewCell.self, bubbleOther: VideoOtherTableViewCell.self
      )
    case .file:
      identifier = getIndentifier(
        from, bubbleMe: FileMeTableViewCell.self, bubbleOther: FileOtherTableViewCell.self
      )
    case .text:
      identifier = getIndentifier(
        from, bubbleMe: TextMeTableViewCell.self, bubbleOther: TextOtherTableViewCell.self
      )
    }
    return identifier
  }
  
  func getIndentifier<T, U>(_ from: MessageModel.ChatFrom, bubbleMe: T.Type, bubbleOther: U.Type) -> String {
    switch from {
    case .me:
      return getIndentifier(objectType: bubbleMe)
    case .other:
      return getIndentifier(objectType: bubbleOther)
    }
  }
  
  protocol FactoryDelete {
    func loadThumbnailAvatar(
      message: MessageModel, index: IndexPath, completion: @escaping (Data?, ImageModel.State) -> Void
    )
    func loadThumbnailImage(
      message: MessageModel, index: IndexPath, completion: @escaping (Data?, ImageModel.State) -> Void
    )
    func loadThumbnailVideo(
      message: MessageModel, index: IndexPath, completion: @escaping (Data?, ImageModel.State) -> Void
    )
    func downloadFile(message: MessageModel, completion: @escaping (MessageModel?, Float?, ChatError?) -> Void)
    func showImage(message: MessageModel)
    func playVideo(videoURL: URL?)
    func openDocument(documentURL: URL?)
  }
}

// MARK: ~ Helper
extension ChatTableViewCellFactory: FileActionDelegate {
  
  private func configureAvatar(_ cell: BaseChatTableViewCell, message: MessageModel, index: IndexPath) {
    if cell.avatarChatImageView.isHidden { return }
    
    if !cell.avatarChatImageView.isLoadImage(
      imageState: message.sender.avatarImage.state,
      dataImage: message.sender.avatarImage.data
    ) { return }
    
    delegate?.loadThumbnailAvatar(message: message, index: index) { dataImage, imageState in
      _ = cell.avatarChatImageView.isLoadImage(imageState: imageState, dataImage: dataImage)
    }
  }
  
  private func configureImageMessage(_ cell: ImageTableViewCell, message: MessageModel, index: IndexPath) {
    cell.delegate = self
    
    if !cell.contentImageView.isLoadImage(
      imageState: message.data.previewImage.state,
      dataImage: message.data.previewImage.data
    ) { return }
    
    delegate?.loadThumbnailImage(message: message, index: index) { dataImage, imageState in
      _ = cell.contentImageView.isLoadImage(imageState: imageState, dataImage: dataImage)
    }
  }
  
  private func configureVideoMessage(_ cell: VideoTableViewCell, message: MessageModel, index: IndexPath) {
    configureHandleUploaded(cell: cell, for: message.status)
    cell.delegate = self
    
    if !cell.contentImageView.isLoadImage(
      imageState: message.data.previewImage.state,
      dataImage: message.data.previewImage.data
    ) { return }
    
    delegate?.loadThumbnailVideo(message: message, index: index) { dataImage, imageState in
      _ = cell.contentImageView.isLoadImage(imageState: imageState, dataImage: dataImage)
    }
  }
  
  func configureHandleUploaded(cell delegate: UploadDelegate, for status: CommentStatus) {
      switch status {
      case .sending, .pending:
        self.uploadelegates.append(delegate)
      default:
        if let index = self.uploadelegates.firstIndex(
          where: { $0.uploadIdentifier() == delegate.uploadIdentifier() }
        ) {
          self.uploadelegates.remove(at: index)
        }
      }
  }
  func downloadFile(message: MessageModel, completion: @escaping (MessageModel?, Float?, ChatError?) -> Void) {
    delegate?.downloadFile(message: message, completion: completion)
  }
  
  func showImage(message: MessageModel) {
    delegate?.showImage(message: message)
  }
  func playVideo(videoURL: URL?) {
    delegate?.playVideo(videoURL: videoURL)
  }
  
  func openDocument(documentURL: URL?) {
    delegate?.openDocument(documentURL: documentURL)
  }
}

protocol FileActionDelegate {
  func downloadFile(message: MessageModel, completion: @escaping (MessageModel?, Float?, ChatError?) -> Void)
  func showImage(message: MessageModel)
  func playVideo(videoURL: URL?)
  func openDocument(documentURL: URL?)
}

protocol UploadDelegate {
  func uploadIdentifier() -> String
  func uploadFile(percent: Double)
}
