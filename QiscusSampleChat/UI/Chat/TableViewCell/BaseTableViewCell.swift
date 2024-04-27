//
//  BaseTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 25/04/24.
//

import UIKit

open class BaseTableViewCell: UITableViewCell {
  
  let dateTimeChatLabel = TextLabel()
  let textChatLabel = TextLabel()
  let timeChatLabel = UILabel()
  let avatarChatImageView = UIImageView()
  var statusChatImageView: UIImageView?
  
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
    
    switch message.chatFrom  {
    case .me:
      configureSendByMe()
      statusChatImageView!.image = generateStatus(status: message.status)
    default:
      configureSendByOther()
    }
  }
  
}

extension BaseTableViewCell {
  
  @objc open func setup() {
    backgroundColor = .clear
    
    dateTimeChatLabel.translatesAutoresizingMaskIntoConstraints = false
    dateTimeChatLabel.accessibilityIdentifier = "dateTimeChatLabel"
    dateTimeChatLabel.textColor = Colors.textDefaultColor
    dateTimeChatLabel.font = UIFont(
      name: Fonts.interRegular, size: Fonts.defaultSize
    )
    dateTimeChatLabel.setPadding(
      top: Dimens.paddingChatVerticalContent, bottom: Dimens.paddingChatVerticalContent,
      left: Dimens.paddingChatHorizontalContent, right: Dimens.paddingChatHorizontalContent
    )
    dateTimeChatLabel.layer.cornerRadius = Dimens.smallest
    dateTimeChatLabel.layer.masksToBounds = true
    dateTimeChatLabel.backgroundColor = Colors.datetTimeChatBacckgroundColor
    
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
    
    addAllViews()
  }
  
  @objc open func layout() {
    addToView(listOfContentView)
    
    activatedWithConstrain([
      timeChatLabel.widthAnchor.constraint(equalToConstant: Fonts.timeChatMinWidth),
      
      avatarChatImageView.topAnchor.constraint(equalTo: timeChatLabel.topAnchor),
      avatarChatImageView.widthAnchor.constraint(equalToConstant: Images.avatarChatSize),
      avatarChatImageView.heightAnchor.constraint(equalToConstant: Images.avatarChatSize)
    ])
  }
  
  @objc open func configureSendByMe() {
    timeChatLabel.textAlignment = .right
    
    if statusChatImageView == nil {
      statusChatImageView = UIImageView()
      statusChatImageView!.translatesAutoresizingMaskIntoConstraints = false
      statusChatImageView!.accessibilityIdentifier = "statusChatImageView"
      contentView.addSubview(statusChatImageView!)
    }
    
    activatedWithConstrain([
      statusChatImageView!.topAnchor.constraint(equalTo: timeChatLabel.bottomAnchor),
      statusChatImageView!.widthAnchor.constraint(equalToConstant: Images.statusChatSize),
      statusChatImageView!.heightAnchor.constraint(equalToConstant: Images.statusChatSize),
      statusChatImageView!.trailingAnchor.constraint(equalTo: timeChatLabel.trailingAnchor),
      
      contentView.trailingAnchor.constraint(equalTo: avatarChatImageView.trailingAnchor, constant: Dimens.small)
    ])
  }
  
  @objc open func configureSendByOther() {
    timeChatLabel.textAlignment = .left
    
    activatedWithConstrain([
      contentView.leadingAnchor.constraint(equalTo: avatarChatImageView.leadingAnchor, constant: -Dimens.small)
    ])
  }
  
  func configureDateTime(message: MessageModel) {
    let listToConstraint: [NSLayoutConstraint]
    if message.isFirst {
      avatarChatImageView.isHidden = false
      dateTimeChatLabel.isHidden = false
      dateTimeChatLabel.text = message.dateTime
      
      contentView.addSubview(dateTimeChatLabel)
      
      listToConstraint = [
        dateTimeChatLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Dimens.smaller),
        dateTimeChatLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        
        timeChatLabel.topAnchor.constraint(equalTo: dateTimeChatLabel.bottomAnchor, constant: Dimens.smaller)
      ]
    } else {
      avatarChatImageView.isHidden = true
      dateTimeChatLabel.isHidden = true
      
      listToConstraint = [
        timeChatLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Dimens.extraSmall)
      ]
    }
    
    activatedWithConstrain(listToConstraint)
  }
}

// MARK: ~ view logic
extension BaseTableViewCell {
  
  private func addAllViews() {
    listOfContentView.append(timeChatLabel)
    listOfContentView.append(avatarChatImageView)
  }
  
  func addToStackView(_ stackView: UIStackView, views: UIView...) {
    for view in views {
      stackView.addArrangedSubview(view)
    }
    contentView.addSubview(stackView)
  }
  
  func addToView(_ views: [UIView]) {
    for view in views {
      contentView.addSubview(view)
    }
  }
  
  func activatedWithConstrain(_ constraints: [NSLayoutConstraint]) {
    NSLayoutConstraint.activate(constraints)
  }
  
  private func generateStatus(status: MessageModel.Status) -> UIImage? {
    switch status {
    case .read:
      return UIImage(named: Images.chatStatusRead)?.withTintColor(Colors.primaryColor)
    case .delivered:
      return UIImage(named: Images.chatStatusRead)
    case .sending:
      return UIImage(named: Images.chatStatusSending)
    case .failed:
      return UIImage(named: Images.chatStatusFailed)?.withTintColor(.red)
    default:
      return nil
    }
  }
  
}
