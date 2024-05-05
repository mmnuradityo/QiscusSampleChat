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
  let downloadButton = UIButton(type: .custom)
  let descriptionLabel = UILabel()
  
  override func configure(message: MessageModel) {
    super.configure(message: message)
    
    textChatLabel.text = message.data.fileName
    descriptionLabel.text = message.data.caption
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
    
    downloadButton.translatesAutoresizingMaskIntoConstraints = false
    downloadButton.accessibilityIdentifier = "downloadButton"
    downloadButton.contentVerticalAlignment = .fill
    downloadButton.contentHorizontalAlignment = .fill
    downloadButton.imageView?.contentMode = .scaleAspectFit
    downloadButton.layer.cornerRadius = Images.downloadChatSize/2
    downloadButton.clipsToBounds = true
    
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.accessibilityIdentifier = "descriptionLabel"
    descriptionLabel.font = UIFont(name: Fonts.interRegular, size: Fonts.descriptionChatSize)
    
    listOfContentView.append(fileBackgroundView)
    listOfContentView.append(fileIconImageView)
    listOfContentView.append(downloadButton)
    listOfContentView.append(textChatLabel)
    listOfContentView.append(descriptionLabel)
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
