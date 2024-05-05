//
//  BaseTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 25/04/24.
//

import UIKit
import QiscusCore

protocol BaseTableViewCellCallerProtocol {
  func configure(message: MessageModel)
}

open class BaseChatTableViewCell: BaseTableViewCell, BaseTableViewCellCallerProtocol {
  
  let dateChatView = ChatDateView()
  let textChatLabel = TextLabel()
  let timeChatLabel = UILabel()
  let avatarChatImageView = UIImageView()
  let statusChatImageView = UIImageView()
  var dateChatViewHeight: NSLayoutConstraint?
  
  var listOfContentView: [UIView] = []
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
    layout()
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(message: MessageModel) {
    timeChatLabel.text = message.time
    configureDateTime(message: message)
    
    switch message.chatFrom {
    case .me:
      configureSendByMe()
      statusChatImageView.image = generateStatus(status: message.status)
    case .other:
      configureSendByOther()
      statusChatImageView.image = nil
    }
  }
  
}

extension BaseChatTableViewCell {
  
  @objc func setup() {
    transform = CGAffineTransform(scaleX: 1, y: -1)
    backgroundColor = .clear
    
    dateChatView.translatesAutoresizingMaskIntoConstraints = false
    dateChatView.accessibilityIdentifier = "dateChatView"
    
    textChatLabel.translatesAutoresizingMaskIntoConstraints = false
    textChatLabel.accessibilityIdentifier = "textChatLabel"
    textChatLabel.font = UIFont(
      name: Fonts.interRegular, size: Fonts.defaultSize
    )
    textChatLabel.numberOfLines = 0
    
    timeChatLabel.translatesAutoresizingMaskIntoConstraints = false
    timeChatLabel.accessibilityIdentifier = "timeChatLabel"
    timeChatLabel.font = UIFont(
      name: Fonts.interRegular, size: Fonts.defaultSize
    )
    
    avatarChatImageView.translatesAutoresizingMaskIntoConstraints = false
    avatarChatImageView.accessibilityIdentifier = "avatarChatImageView"
    avatarChatImageView.layer.cornerRadius = Images.avatarChatSize/2
    avatarChatImageView.clipsToBounds = true
    
    statusChatImageView.translatesAutoresizingMaskIntoConstraints = false
    statusChatImageView.accessibilityIdentifier = "statusChatImageView"
    
    addAllViews()
  }
  
  @objc func layout() {
    addToView(listOfContentView)
    
    dateChatViewHeight = dateChatView.heightAnchor.constraint(equalToConstant: Dimens.chatDatetHeight)
    
        activatedWithConstraint([
      timeChatLabel.widthAnchor.constraint(equalToConstant: Fonts.timeChatMinWidth),
      
      avatarChatImageView.topAnchor.constraint(equalTo: timeChatLabel.topAnchor),
      avatarChatImageView.widthAnchor.constraint(equalToConstant: Images.avatarChatSize),
      avatarChatImageView.heightAnchor.constraint(equalToConstant: Images.avatarChatSize),
      
      statusChatImageView.topAnchor.constraint(equalTo: timeChatLabel.bottomAnchor),
      statusChatImageView.widthAnchor.constraint(equalToConstant: Images.statusChatSize),
      statusChatImageView.heightAnchor.constraint(equalToConstant: Images.statusChatSize),
      statusChatImageView.trailingAnchor.constraint(equalTo: timeChatLabel.trailingAnchor),
      
      dateChatView.topAnchor.constraint(equalTo: contentView.topAnchor),
      dateChatView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      dateChatViewHeight!,
      
      timeChatLabel.topAnchor.constraint(equalTo: dateChatView.bottomAnchor, constant: Dimens.extraSmall)
    ])
  }
  
  private func configureDateTime(message: MessageModel) {
    if message.isShowDate {
      dateChatView.isHidden = false
      dateChatView.dateTimeChatLabel.text = message.dateString
      dateChatViewHeight?.constant = Dimens.chatDatetHeight
      
    } else {
      dateChatView.isHidden = true
      dateChatViewHeight?.constant = 0
    }
    
    avatarChatImageView.isHidden = !(message.isFirst || message.isShowDate)
  }
  
  @objc func configureSendByMe() {
    timeChatLabel.textAlignment = .right
    statusChatImageView.isHidden = false
    
    activatedWithConstraint([
      contentView.trailingAnchor.constraint(equalTo: avatarChatImageView.trailingAnchor, constant: Dimens.small)
    ])
  }
  
  @objc func configureSendByOther() {
    timeChatLabel.textAlignment = .left
    statusChatImageView.isHidden = true
    
    activatedWithConstraint([
      contentView.leadingAnchor.constraint(equalTo: avatarChatImageView.leadingAnchor, constant: -Dimens.small)
    ])
  }
  
}

// MARK: ~ view logic
extension BaseChatTableViewCell {
  
  private func addAllViews() {
    listOfContentView.append(dateChatView)
    listOfContentView.append(timeChatLabel)
    listOfContentView.append(avatarChatImageView)
    listOfContentView.append(statusChatImageView)
  }
  
  func generateStatus(status: CommentStatus) -> UIImage? {
    switch status {
    case .read:
      return UIImage(named: Images.chatStatusRead)?.withTintColor(Colors.primaryColor)
    case .sent, .delivered:
      return UIImage(named: Images.chatStatusRead)
    case .sending:
      return UIImage(named: Images.chatStatusSending)
    case .pending:
      return UIImage(named: Images.chatStatusFailed)
    case .failed, .deleting, .deleted:
      return UIImage(named: Images.chatStatusFailed)?.withTintColor(.red)
    }
  }
  
}
