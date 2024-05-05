//
//  TextOtherTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 28/04/24.
//

import UIKit

final class TextOtherTableViewCell: TextTableViewCell {
  
  override func configureSendByOther() {
    super.configureSendByOther()
    
    chatFromImageView.image = UIImage(named: Images.chatFromOther)
    textChatLabel.backgroundColor = Colors.bubleOtherColor
    textChatLabel.textColor = Colors.textDefaultColor
    
    activatedWithConstraint([
      contentView.trailingAnchor.constraint(greaterThanOrEqualTo: timeChatLabel.trailingAnchor, constant: Dimens.marginChatSpace),
      
      textChatLabel.trailingAnchor.constraint(equalTo: timeChatLabel.leadingAnchor, constant: -Dimens.contentChatEndSpace),
      textChatLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Dimens.contentChatFromAvatarSpace),
      
      chatFromImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Dimens.chatFromAvatarSpace),
    ])
  }
}
