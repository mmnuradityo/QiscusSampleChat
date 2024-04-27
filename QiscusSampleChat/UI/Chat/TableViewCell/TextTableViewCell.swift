//
//  TextTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 25/04/24.
//

import UIKit

class TextTableViewCell: BaseTableViewCell {
  let chatFromImageView = UIImageView()
  
  override func configure(message: MessageModel) {
    super.configure(message: message)
    
    textChatLabel.text = message.data.caption
    
    chatFromImageView.isHidden = !message.isFirst
  }
}

// MARK: - setup and layouting
extension TextTableViewCell {
  
  override func setup() {
    super.setup()
    
    dateTimeChatLabel.text = "Monday, March 9, 2020"
    
    chatFromImageView.translatesAutoresizingMaskIntoConstraints = false
    chatFromImageView.accessibilityIdentifier = "chatFromImageView"
    
    textChatLabel.layer.cornerRadius = Dimens.smallest
    textChatLabel.layer.masksToBounds = true
    textChatLabel.setPadding(
      top: Dimens.paddingChatVerticalContent, bottom: Dimens.paddingChatVerticalContent,
      left: Dimens.paddingChatHorizontalContent, right: Dimens.paddingChatHorizontalContent
    )
    
    listOfContentView.append(chatFromImageView)
    listOfContentView.append(textChatLabel)
  }
  
  override func layout() {
    super.layout()
    
    activatedWithConstrain([
      textChatLabel.topAnchor.constraint(equalTo: timeChatLabel.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: textChatLabel.bottomAnchor, constant: Dimens.extraSmall),
      
      chatFromImageView.topAnchor.constraint(equalTo: textChatLabel.topAnchor),
      chatFromImageView.widthAnchor.constraint(equalToConstant: Images.chatFromSize),
      chatFromImageView.heightAnchor.constraint(equalToConstant: Images.chatFromSize)
    ])
  }
  
  override func configureSendByMe() {
    super.configureSendByMe()
    chatFromImageView.image = UIImage(named: Images.chatFromMe)
    textChatLabel.backgroundColor = Colors.primaryColor
    textChatLabel.textColor = .white
    
    activatedWithConstrain([
      timeChatLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: Dimens.marginChatSpace),
      
      textChatLabel.leadingAnchor.constraint(equalTo: timeChatLabel.trailingAnchor, constant: Dimens.contentChatEndSpace),
      textChatLabel.trailingAnchor.constraint(equalTo: avatarChatImageView.leadingAnchor, constant: -Dimens.contentChatStartSpace),
      
      chatFromImageView.trailingAnchor.constraint(equalTo: avatarChatImageView.leadingAnchor, constant: -Dimens.contentChatEndSpace),
    ])
  }
  
  override func configureSendByOther() {
    super.configureSendByOther()
    chatFromImageView.image = UIImage(named: Images.chatFromOther)
    textChatLabel.backgroundColor = Colors.bubleOtherColor
    textChatLabel.textColor = Colors.textDefaultColor
    
    activatedWithConstrain([
      contentView.trailingAnchor.constraint(greaterThanOrEqualTo: timeChatLabel.trailingAnchor, constant: Dimens.marginChatSpace),
      
      textChatLabel.trailingAnchor.constraint(equalTo: timeChatLabel.leadingAnchor, constant: -Dimens.contentChatEndSpace),
      textChatLabel.leadingAnchor.constraint(equalTo: avatarChatImageView.trailingAnchor, constant: Dimens.contentChatStartSpace),
      
      chatFromImageView.leadingAnchor.constraint(equalTo: avatarChatImageView.trailingAnchor, constant: Dimens.contentChatEndSpace),
    ])
  }
}
