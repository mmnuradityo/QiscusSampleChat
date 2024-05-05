//
//  TextTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 25/04/24.
//

import UIKit

class TextTableViewCell: BaseChatTableViewCell {
  let chatFromImageView = UIImageView()
  
  override func configure(message: MessageModel) {
    super.configure(message: message)
    
    textChatLabel.text = message.data.caption
    chatFromImageView.isHidden = !(message.isFirst || message.isShowDate)
  }
}

// MARK: - setup and layouting
extension TextTableViewCell {
  
  override func setup() {
    super.setup()
    
    chatFromImageView.translatesAutoresizingMaskIntoConstraints = false
    chatFromImageView.accessibilityIdentifier = "chatFromImageView"
    
    textChatLabel.layer.cornerRadius = Dimens.smallest
    textChatLabel.layer.masksToBounds = true
    textChatLabel.setPadding(
      top: Dimens.paddingChatVerticalContent, bottom: Dimens.paddingChatVerticalContent,
      left: Dimens.paddingChatHorizontalContent, right: Dimens.paddingChatHorizontalContent
    )
    textChatLabel.isHidden = false
    
    listOfContentView.append(chatFromImageView)
    listOfContentView.append(textChatLabel)
  }
  
  override func layout() {
    super.layout()
    
    activatedWithConstraint([
      textChatLabel.topAnchor.constraint(equalTo: timeChatLabel.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: textChatLabel.bottomAnchor, constant: Dimens.extraSmall),
      
      chatFromImageView.topAnchor.constraint(equalTo: textChatLabel.topAnchor),
      chatFromImageView.widthAnchor.constraint(equalToConstant: Images.chatFromSize),
      chatFromImageView.heightAnchor.constraint(equalToConstant: Images.chatFromSize)
    ])
  }
  
}
