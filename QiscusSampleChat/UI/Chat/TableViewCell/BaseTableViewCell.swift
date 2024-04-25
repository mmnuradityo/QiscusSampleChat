//
//  BaseTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 25/04/24.
//

import UIKit

open class BaseTableViewCell: UITableViewCell {
  
  let textChatLabel = UILabel()
  let timeChatLabel = UILabel()
  let avatarChatImageView = UIImageView()
  let statusChatImageView = UIImageView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupComponent()
    layoutComponent()
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension BaseTableViewCell {
  
  private func setupComponent() {
    textChatLabel.translatesAutoresizingMaskIntoConstraints = false
    textChatLabel.accessibilityIdentifier = "textChatLabel"
    
    timeChatLabel.translatesAutoresizingMaskIntoConstraints = false
    timeChatLabel.accessibilityIdentifier = "timeChatLabel"
    
    avatarChatImageView.translatesAutoresizingMaskIntoConstraints = false
    avatarChatImageView.accessibilityIdentifier = "avatarChatImageView"
    avatarChatImageView.layer.cornerRadius = Images.avatarChatSize/2
    avatarChatImageView.backgroundColor = Colors.primaryColor
    avatarChatImageView.clipsToBounds = true
    
    statusChatImageView.translatesAutoresizingMaskIntoConstraints = false
    statusChatImageView.accessibilityIdentifier = "statusChatImageView"
    statusChatImageView.backgroundColor = Colors.strokeColor
  }
  
  private func layoutComponent() {
    addToView(
      textChatLabel, timeChatLabel, avatarChatImageView, statusChatImageView
    )
    
    activatedWithConstrain([
      avatarChatImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Dimens.small),
      contentView.trailingAnchor.constraint(equalTo: avatarChatImageView.trailingAnchor, constant: Dimens.small),
      avatarChatImageView.widthAnchor.constraint(equalToConstant: Images.avatarChatSize),
      avatarChatImageView.heightAnchor.constraint(equalToConstant: Images.avatarChatSize),
      
      timeChatLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Dimens.small),
      timeChatLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Dimens.marginChatSpace),
      
      statusChatImageView.topAnchor.constraint(equalTo: timeChatLabel.bottomAnchor),
      statusChatImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Dimens.marginChatSpace),
      statusChatImageView.widthAnchor.constraint(equalToConstant: Images.statusChatSize),
      statusChatImageView.heightAnchor.constraint(equalToConstant: Images.statusChatSize)
    ])
  }
}

// MARK: ~ view logic
extension BaseTableViewCell {
  
  func addToStackView(_ stackView: UIStackView, views: UIView...) {
    for view in views {
      stackView.addArrangedSubview(view)
    }
    contentView.addSubview(stackView)
  }
  
  func addToView(_ views: UIView...) {
    for view in views {
      contentView.addSubview(view)
    }
  }
  
  func activatedWithConstrain(_ constraints: [NSLayoutConstraint]) {
    NSLayoutConstraint.activate(constraints)
  }
  
}
