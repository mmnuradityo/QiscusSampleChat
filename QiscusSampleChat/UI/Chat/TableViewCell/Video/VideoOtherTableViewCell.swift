//
//  VideoOtherTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 28/04/24.
//

import Foundation

class VideoOtherTableViewCell: VideoTableViewCell {
  
  override func configureSendByOther() {
    super.configureSendByOther()
    textChatLabel.backgroundColor = Colors.bubleOtherColor
    textChatLabel.textColor = Colors.textDefaultColor
    
    activatedWithConstraint([
      timeChatLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Dimens.marginChatSpace),
      contentImageView.trailingAnchor.constraint(equalTo: timeChatLabel.leadingAnchor, constant: -Dimens.contentChatEndSpace),
      contentImageView.leadingAnchor.constraint(equalTo: avatarChatImageView.trailingAnchor, constant: Dimens.contentChatStartSpace),
      
      videoCoverView.trailingAnchor.constraint(equalTo: contentImageView.trailingAnchor),
      videoCoverView.leadingAnchor.constraint(equalTo: contentImageView.leadingAnchor),
      
      videoCoverView.leadingAnchor.constraint(equalTo: durationLabel.leadingAnchor, constant: -Dimens.smaller)
    ])
  }
  
}
