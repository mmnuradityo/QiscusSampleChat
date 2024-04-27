//
//  FileTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 26/04/24.
//

import UIKit

class FileTableViewCell: BaseTableViewCell {
  
  let fileBackgroundView = UIView()
  let fileIconImageView = UIImageView()
  let downloadButton = UIButton(type: .custom)
  let descriptionLabel = UILabel()
  
  override func configure(message: MessageModel) {
    super.configure(message: message)
    
    textChatLabel.text = message.data.fileName
    descriptionLabel.text = "File Description"
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
    
    activatedWithConstrain([
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
  
  override func configureSendByMe() {
    super.configureSendByMe()
    fileBackgroundView.backgroundColor = Colors.primaryColor
    fileIconImageView.image = UIImage(named: Images.chatFile)
    downloadButton.setImage(UIImage(named: Images.chatDownload), for: .normal)
    textChatLabel.textColor = .white
    descriptionLabel.textColor = .white
    
    activatedWithConstrain([
      timeChatLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Dimens.marginChatSpace),
      
      fileBackgroundView.leadingAnchor.constraint(equalTo: timeChatLabel.trailingAnchor, constant: Dimens.contentChatEndSpace),
      fileBackgroundView.trailingAnchor.constraint(equalTo: avatarChatImageView.leadingAnchor, constant: -Dimens.contentChatStartSpace),
    ])
  }
  
  override func configureSendByOther() {
    super.configureSendByOther()
    fileBackgroundView.backgroundColor = Colors.bubleOtherColor
    fileIconImageView.image = UIImage(named: Images.chatFileOther)
    downloadButton.setImage(UIImage(named: Images.chatDownloadOther), for: .normal)
    textChatLabel.textColor = Colors.textDefaultColor
    descriptionLabel.textColor = Colors.textDefaultColor
    
    activatedWithConstrain([
      timeChatLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Dimens.marginChatSpace),
      
      fileBackgroundView.trailingAnchor.constraint(equalTo: timeChatLabel.leadingAnchor, constant: -Dimens.contentChatEndSpace),
      fileBackgroundView.leadingAnchor.constraint(equalTo: avatarChatImageView.trailingAnchor, constant: Dimens.contentChatStartSpace),
    ])
  }
  
}
