//
//  VideoMeTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 28/04/24.
//

import Foundation

class VideoMeTableViewCell: VideoTableViewCell {
  
  override func configureSendByMe() {
    super.configureSendByMe()
    textChatLabel.backgroundColor = Colors.primaryColor
    textChatLabel.textColor = .white
    
    activatedWithConstraint([
      timeChatLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Dimens.marginChatSpace),
      contentImageView.leadingAnchor.constraint(equalTo: timeChatLabel.trailingAnchor, constant: Dimens.contentChatEndSpace),
      contentImageView.trailingAnchor.constraint(equalTo: avatarChatImageView.leadingAnchor, constant: -Dimens.contentChatStartSpace),
      
      videoCoverView.leadingAnchor.constraint(equalTo: contentImageView.leadingAnchor),
      videoCoverView.trailingAnchor.constraint(equalTo: contentImageView.trailingAnchor),
      
      videoCoverView.trailingAnchor.constraint(equalTo: durationLabel.trailingAnchor, constant: Dimens.smaller)
    ])
  }
  
}
