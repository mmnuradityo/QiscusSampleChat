//
//  NotSupportTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 27/04/24.
//

import UIKit

class NotSupportTableViewCell: UITableViewCell, BaseTableViewCellCallerProtocol {
  
  let textChatLabel = TextLabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    transform = CGAffineTransform(scaleX: 1, y: -1)
    
    textChatLabel.translatesAutoresizingMaskIntoConstraints = false
    textChatLabel.accessibilityIdentifier = "textChatLabel"
    textChatLabel.font = UIFont(
      name: Fonts.interRegular, size: Fonts.defaultSize
    )
    textChatLabel.numberOfLines = 1
    textChatLabel.textColor = .white
    textChatLabel.backgroundColor = .systemRed
    textChatLabel.layer.cornerRadius = Dimens.smallest
    textChatLabel.clipsToBounds = true
    textChatLabel.setPadding(
      top: Dimens.paddingChatVerticalContent, bottom: Dimens.paddingChatVerticalContent,
      left: Dimens.paddingChatHorizontalContent, right: Dimens.paddingChatHorizontalContent
    )
    
    contentView.addSubview(textChatLabel)
    
    NSLayoutConstraint.activate([
      textChatLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      textChatLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Dimens.smallest),
      contentView.bottomAnchor.constraint(equalTo: textChatLabel.bottomAnchor, constant: Dimens.smallest),
      textChatLabel.heightAnchor.constraint(equalToConstant: Dimens.chatNotSupportHeight)
    ])
    
  }
  
  func configure(message: MessageModel) {
    textChatLabel.text = "Message type not supported"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
