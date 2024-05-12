//
//  FileTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 26/04/24.
//

import UIKit

class FileTableViewCell: BaseChatTableViewCell {
  
  let fileBackgroundView = UIView()
  let fileIconImageView = UIImageView()
  let descriptionLabel = UILabel()
  let downloadButton = CarrierButton<MessageModel>(type: .custom)
  let downloadProgressView = CircelIndetermineProgressView()
  
  var delegate: FileActionDelegate?
  var tapGesture: CarrierTapGesture<MessageModel>?
  var cellUploadIdentifier: String = ""
  
  override func configure(message: MessageModel) {
    super.configure(message: message)
    cellUploadIdentifier = message.id
    textChatLabel.text = message.data.fileName
    
    let fileSize = message.data.extras[MessageDataExtraParams.size.rawValue] ?? "0"
    let fileExtention = message.data.extras[MessageDataExtraParams.extention.rawValue] ?? "unknow"
    descriptionLabel.text = "\(fileSize) - \(fileExtention) file"
    
    downloadButton.isHidden = message.data.isDownloaded
    downloadProgressView.isHidden = true
    
    if !downloadButton.isHidden {
      downloadButton.data = message
      downloadButton.removeTarget(self, action: #selector(downloadButtonTaped), for: .touchUpInside)
      downloadButton.addTarget(self, action: #selector(downloadButtonTaped), for: .touchUpInside)
    } else {
      if tapGesture != nil {
        fileBackgroundView.removeGestureRecognizer(tapGesture!)
      }
      tapGesture = CarrierTapGesture(target: self, action: #selector(fileBackgroundTaped))
      tapGesture?.delegate = self
      tapGesture?.data = message
      fileBackgroundView.isUserInteractionEnabled = true
      fileBackgroundView.addGestureRecognizer(tapGesture!)
    }
  }
  
}

// MARK: - setup and layouting
extension FileTableViewCell {
  
  override func setup() {
    super.setup()
    
    textChatLabel.numberOfLines = 1
    textChatLabel.font = UIFont(name: Fonts.interSemiBold, size: Fonts.defaultSize)
    
    fileBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    fileBackgroundView.accessibilityIdentifier = "fileBackgroundView"
    fileBackgroundView.layer.cornerRadius = Dimens.smallest
    fileBackgroundView.clipsToBounds = true
    
    fileIconImageView.translatesAutoresizingMaskIntoConstraints = false
    fileIconImageView.accessibilityIdentifier = "fileIconImageView"
    
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.accessibilityIdentifier = "descriptionLabel"
    descriptionLabel.font = UIFont(name: Fonts.interRegular, size: Fonts.descriptionChatSize)
    
    downloadButton.translatesAutoresizingMaskIntoConstraints = false
    downloadButton.accessibilityIdentifier = "downloadButton"
    downloadButton.contentVerticalAlignment = .fill
    downloadButton.contentHorizontalAlignment = .fill
    downloadButton.imageView?.contentMode = .scaleAspectFit
    downloadButton.layer.cornerRadius = Images.downloadChatSize/2
    downloadButton.clipsToBounds = true
    
    downloadProgressView.translatesAutoresizingMaskIntoConstraints = false
    downloadProgressView.accessibilityIdentifier = "descriptionLabel"
    downloadProgressView.strokeColor = UIColor.black
    downloadProgressView.isHidden = true
    
    listOfContentView.append(fileBackgroundView)
    listOfContentView.append(fileIconImageView)
    listOfContentView.append(downloadButton)
    listOfContentView.append(textChatLabel)
    listOfContentView.append(descriptionLabel)
    listOfContentView.append(downloadProgressView)
  }
  
  override func layout() {
    super.layout()
    
    activatedWithConstraint([
      fileBackgroundView.topAnchor.constraint(equalTo: timeChatLabel.topAnchor),
      contentView.bottomAnchor.constraint(greaterThanOrEqualTo: fileBackgroundView.bottomAnchor, constant: Dimens.extraSmall),
      fileBackgroundView.heightAnchor.constraint(equalToConstant: Images.fileChatContentHeight),
      
      fileIconImageView.centerYAnchor.constraint(equalTo: fileBackgroundView.centerYAnchor),
      fileIconImageView.leadingAnchor.constraint(equalTo: fileBackgroundView.leadingAnchor, constant: Dimens.paddingChatHorizontalContent),
      fileIconImageView.widthAnchor.constraint(equalToConstant: Images.fileChatSize),
      fileIconImageView.heightAnchor.constraint(equalToConstant: Images.fileChatSize),
      
      fileBackgroundView.trailingAnchor.constraint(equalTo: downloadButton.trailingAnchor, constant: Dimens.paddingChatDownloadFile),
      fileBackgroundView.bottomAnchor.constraint(equalTo: downloadButton.bottomAnchor, constant: Dimens.paddingChatDownloadFile),
      downloadButton.heightAnchor.constraint(equalToConstant: Images.downloadChatSize),
      downloadButton.widthAnchor.constraint(equalToConstant: Images.downloadChatSize),
      
      downloadProgressView.topAnchor.constraint(equalTo: downloadButton.topAnchor),
      downloadProgressView.bottomAnchor.constraint(equalTo: downloadButton.bottomAnchor),
      downloadProgressView.leadingAnchor.constraint(equalTo: downloadButton.leadingAnchor),
      downloadProgressView.leadingAnchor.constraint(equalTo: downloadButton.leadingAnchor),
      downloadProgressView.trailingAnchor.constraint(equalTo: downloadButton.trailingAnchor),
      
      textChatLabel.topAnchor.constraint(equalTo: fileBackgroundView.topAnchor, constant: Dimens.smaller),
      textChatLabel.leadingAnchor.constraint(equalTo: fileIconImageView.trailingAnchor, constant: Dimens.smallest),
      fileBackgroundView.trailingAnchor.constraint(equalTo: textChatLabel.trailingAnchor, constant: Dimens.medium),
      
      descriptionLabel.topAnchor.constraint(equalTo: textChatLabel.bottomAnchor, constant: Dimens.extraSmall),
      descriptionLabel.leadingAnchor.constraint(equalTo: textChatLabel.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: downloadButton.leadingAnchor, constant: -Dimens.paddingChatDescriptionFile),
      fileBackgroundView.bottomAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor, constant: Dimens.smaller)
    ])
  }
  
}

// MARK: - Action
extension FileTableViewCell: UploadDelegate {
  
  @objc func downloadButtonTaped(_ sender: UIButton) {
    if !downloadButton.isHidden {
      downloadButton.isHidden = true
      downloadProgressView.isHidden = false
      
      guard let message = (sender as! CarrierButton<MessageModel>).data else { return }
      delegate?.downloadFile(message: message, completion: { messageResult, progress, error in
        if messageResult != nil {
          self.configure(message: messageResult!)
        } else if error != nil {
          self.downloadButton.isHidden = false
          self.downloadProgressView.isHidden = true
        }
      })
    }
  }
  
  @objc func fileBackgroundTaped(_ sender: UITapGestureRecognizer) {
    guard let message = (sender as! CarrierTapGesture<MessageModel>).data else { return }
    delegate?.openDocument(documentURL: message.data.url)
  }
  
  func uploadIdentifier() -> String {
    return cellUploadIdentifier
  }
  
  func uploadFile(percent: Double) {
    downloadButton.isHidden = true
    downloadProgressView.isHidden = percent == 0
  }
  
}
