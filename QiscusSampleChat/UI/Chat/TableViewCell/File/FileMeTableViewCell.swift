//
//  FileMeTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 28/04/24.
//

import UIKit

class FileMeTableViewCell: FileTableViewCell {
  
  override func configureSendByMe() {
    super.configureSendByMe()
    fileBackgroundView.backgroundColor = Colors.primaryColor
    fileIconImageView.image = UIImage(named: Images.chatFile)
    downloadButton.setImage(UIImage(named: Images.chatDownload), for: .normal)
    textChatLabel.textColor = .white
    descriptionLabel.textColor = .white
    
    activatedWithConstraint([
      timeChatLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Dimens.marginChatSpace),
      
      fileBackgroundView.leadingAnchor.constraint(equalTo: timeChatLabel.trailingAnchor, constant: Dimens.contentChatEndSpace),
      fileBackgroundView.trailingAnchor.constraint(equalTo: avatarChatImageView.leadingAnchor, constant: -Dimens.contentChatStartSpace),
    ])
  }
  
}
