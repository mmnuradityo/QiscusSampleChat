//
//  ImageTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 26/04/24.
//

import UIKit

class ImageTableViewCell: BaseChatTableViewCell {
  
  let contentImageView = UIImageView()
  
  var tapGesture: CarrierTapGesture<MessageModel>?
  var delegate: FileActionDelegate?
  
  override func configure(message: MessageModel) {
    super.configure(message: message)
    
    if message.data.caption.isEmpty {
      textChatLabel.isHidden = true
    } else {
      textChatLabel.isHidden = false
      textChatLabel.text = message.data.caption
    }
    
    if message.data.dataType == .image {
      if tapGesture != nil {
        contentImageView.removeGestureRecognizer(tapGesture!)
      }
      tapGesture = CarrierTapGesture(target: self, action: #selector(contentImageViewTapped))
      tapGesture?.data = message
      contentImageView.isUserInteractionEnabled = true
      contentImageView.addGestureRecognizer(tapGesture!)
    }
    
    configureComponent()
  }
  
}

// MARK: - setup and layouting
extension ImageTableViewCell {
  
  override func setup() {
    super.setup()
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
    
    activatedWithConstraint([
      contentImageView.topAnchor.constraint(equalTo: timeChatLabel.topAnchor),
      contentView.bottomAnchor.constraint(greaterThanOrEqualTo: contentImageView.bottomAnchor, constant: Dimens.extraSmall),
      contentImageView.heightAnchor.constraint(equalToConstant: Images.imageChatContentHeight)
    ])
  }
  
  @objc func configureComponent() {
    if !textChatLabel.isHidden {
      activatedWithConstraint([
        textChatLabel.topAnchor.constraint(equalTo: contentImageView.topAnchor, constant: Dimens.paddingChatVerticalImageContent),
        textChatLabel.leadingAnchor.constraint(equalTo: contentImageView.leadingAnchor),
        textChatLabel.trailingAnchor.constraint(equalTo: contentImageView.trailingAnchor),
        contentView.bottomAnchor.constraint(equalTo: textChatLabel.bottomAnchor, constant: Dimens.extraSmall)
      ])
    }
  }
  
}

extension ImageTableViewCell {
  
  @objc func contentImageViewTapped(_ sender: UITapGestureRecognizer) {
    guard let message = (sender as! CarrierTapGesture<MessageModel>).data else { return }
    delegate?.showImage(message: message)
  }
  
}
