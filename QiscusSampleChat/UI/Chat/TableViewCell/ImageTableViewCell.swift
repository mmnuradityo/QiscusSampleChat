//
//  ImageTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 26/04/24.
//

import UIKit

class ImageTableViewCell: BaseTableViewCell {
  let contentImageView = UIImageView()
  
  override func configure(message: MessageModel) {
    super.configure(message: message)
    
    if message.data.caption.isEmpty {
      textChatLabel.isHidden = true
    } else {
      textChatLabel.text = message.data.caption
    }
    
    configureComponent()
  }
}

// MARK: - setup and layouting
extension ImageTableViewCell {
  
  override func setup() {
    super.setup()
    
    dateTimeChatLabel.text = "Monday, March 9, 2020"
    
    textChatLabel.layer.cornerRadius = Dimens.smallest
    textChatLabel.layer.masksToBounds = true
    textChatLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    textChatLabel.setPadding(
      top: Dimens.paddingChatVerticalContent, bottom: Dimens.paddingChatVerticalContent,
      left: Dimens.paddingChatHorizontalContent, right: Dimens.paddingChatHorizontalContent
    )
    
    contentImageView.translatesAutoresizingMaskIntoConstraints = false
    contentImageView.accessibilityIdentifier = "contentImageView"
    contentImageView.image = UIImage(named: Images.chatPlaceholder)
    contentImageView.layer.cornerRadius = Dimens.smallest
    contentImageView.contentMode = .scaleAspectFill
    contentImageView.clipsToBounds = true
    
    listOfContentView.append(contentImageView)
    listOfContentView.append(textChatLabel)
  }
  
  override func layout() {
    super.layout()
    
    activatedWithConstrain([
      contentImageView.topAnchor.constraint(equalTo: timeChatLabel.topAnchor),
      contentView.bottomAnchor.constraint(greaterThanOrEqualTo: contentImageView.bottomAnchor, constant: Dimens.extraSmall),
      contentImageView.heightAnchor.constraint(equalToConstant: Images.imageChatContentHeight)
    ])
  }
  
  override func configureSendByMe() {
    super.configureSendByMe()
    textChatLabel.backgroundColor = Colors.primaryColor
    textChatLabel.textColor = .white
    
    activatedWithConstrain([
      timeChatLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Dimens.marginChatSpace),
      contentImageView.leadingAnchor.constraint(equalTo: timeChatLabel.trailingAnchor, constant: Dimens.contentChatEndSpace),
      contentImageView.trailingAnchor.constraint(equalTo: avatarChatImageView.leadingAnchor, constant: -Dimens.contentChatStartSpace),
    ])
  }
  
  override func configureSendByOther() {
    super.configureSendByOther()
    textChatLabel.backgroundColor = Colors.bubleOtherColor
    textChatLabel.textColor = Colors.textDefaultColor
    
    activatedWithConstrain([
      timeChatLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Dimens.marginChatSpace),
      contentImageView.trailingAnchor.constraint(equalTo: timeChatLabel.leadingAnchor, constant: -Dimens.contentChatEndSpace),
      contentImageView.leadingAnchor.constraint(equalTo: avatarChatImageView.trailingAnchor, constant: Dimens.contentChatStartSpace),
    ])
  }
  
  @objc func configureComponent() {
    if !textChatLabel.isHidden {
      activatedWithConstrain([
        textChatLabel.topAnchor.constraint(equalTo: contentImageView.topAnchor, constant: Dimens.paddingChatVerticalImageContent),
        textChatLabel.leadingAnchor.constraint(equalTo: contentImageView.leadingAnchor),
        textChatLabel.trailingAnchor.constraint(equalTo: contentImageView.trailingAnchor),
        contentView.bottomAnchor.constraint(equalTo: textChatLabel.bottomAnchor, constant: Dimens.extraSmall)
      ])
    }
  }
  
}

