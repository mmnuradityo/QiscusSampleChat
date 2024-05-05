//
//  FileOtherTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 28/04/24.
//

import UIKit

class FileOtherTableViewCell: FileTableViewCell {
  
  override func configureSendByOther() {
    super.configureSendByOther()
    fileBackgroundView.backgroundColor = Colors.bubleOtherColor
    fileIconImageView.image = UIImage(named: Images.chatFileOther)
    downloadButton.setImage(UIImage(named: Images.chatDownloadOther), for: .normal)
    textChatLabel.textColor = Colors.textDefaultColor
    descriptionLabel.textColor = Colors.textDefaultColor
    
    activatedWithConstraint([
      timeChatLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Dimens.marginChatSpace),
      
      fileBackgroundView.trailingAnchor.constraint(equalTo: timeChatLabel.leadingAnchor, constant: -Dimens.contentChatEndSpace),
      fileBackgroundView.leadingAnchor.constraint(equalTo: avatarChatImageView.trailingAnchor, constant: Dimens.contentChatStartSpace),
    ])
  }
  
}
