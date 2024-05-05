//
//  ImageMeTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 28/04/24.
//

import Foundation

class ImageMeTableViewCell: ImageTableViewCell {
  
  override func configureSendByMe() {
    super.configureSendByMe()
    textChatLabel.backgroundColor = Colors.primaryColor
    textChatLabel.textColor = .white
    
    activatedWithConstraint([
      timeChatLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Dimens.marginChatSpace),
      contentImageView.leadingAnchor.constraint(equalTo: timeChatLabel.trailingAnchor, constant: Dimens.contentChatEndSpace),
      contentImageView.trailingAnchor.constraint(equalTo: avatarChatImageView.leadingAnchor, constant: -Dimens.contentChatStartSpace)
    ])
  }
  
}
