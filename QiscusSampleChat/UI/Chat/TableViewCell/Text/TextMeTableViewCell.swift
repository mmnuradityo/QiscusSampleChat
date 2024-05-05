//
//  TextMeTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 28/04/24.
//

import UIKit

final class TextMeTableViewCell: TextTableViewCell {
  
  override func configureSendByMe() {
    super.configureSendByMe()
    
    chatFromImageView.image = UIImage(named: Images.chatFromMe)
    textChatLabel.backgroundColor = Colors.primaryColor
    textChatLabel.textColor = .white
    
    activatedWithConstraint([
      timeChatLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: Dimens.marginChatSpace),
      
      textChatLabel.leadingAnchor.constraint(equalTo: timeChatLabel.trailingAnchor, constant: Dimens.contentChatEndSpace),
      textChatLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Dimens.contentChatFromAvatarSpace),
      
      chatFromImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Dimens.chatFromAvatarSpace),
    ])
  }
  
}
