//
//  ChatToolbarView.swift
//  QiscusSampleChat
//
//  Created by Admin on 24/04/24.
//

import UIKit

class ChatToolbarView: BaseCustomView {
  
  let backArrowButton = UIButton()
  let avatarImageView = UIImageView()
  let userNameLabel = UILabel()
  let userMemberLabel = UILabel()
  let menuOptionsButton = UIButton()
  
  var delegate: ChatToolbarViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    style()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIView.noIntrinsicMetric, height: Dimens.toolbarHeight)
  }
}

extension ChatToolbarView {
  
  func style() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = Colors.primaryColor
    
    backArrowButton.translatesAutoresizingMaskIntoConstraints = false
    backArrowButton.accessibilityIdentifier = "backArrowButton"
    backArrowButton.setBackgroundImage(
      UIImage(named: Images.backArrow), for: .normal
    )
    backArrowButton.addTarget(self, action: #selector(backArrowButtonDidTapped), for: .touchUpInside)
    
    avatarImageView.translatesAutoresizingMaskIntoConstraints = false
    avatarImageView.accessibilityIdentifier = "avatarImageView"
    avatarImageView.layer.cornerRadius = Images.avatarSize/2
    avatarImageView.clipsToBounds = true
    
    userNameLabel.translatesAutoresizingMaskIntoConstraints = false
    userNameLabel.accessibilityIdentifier = "userNameLabel"
    userNameLabel.font = UIFont(
      name: Fonts.interSemiBold, size: Fonts.toolbarTitleSize
    )
    userNameLabel.textColor = .white
    
    userMemberLabel.translatesAutoresizingMaskIntoConstraints = false
    userMemberLabel.accessibilityIdentifier = "userMemberLabel"
    userMemberLabel.font = UIFont(
      name: Fonts.interRegular, size: Fonts.toolbarSubtitleSize
    )
    userMemberLabel.textColor = .white
    
    menuOptionsButton.translatesAutoresizingMaskIntoConstraints = false
    menuOptionsButton.accessibilityIdentifier = "menuOptionsButton"
    menuOptionsButton.layer.masksToBounds = true
    menuOptionsButton.layer.cornerRadius = Dimens.medium / 2
    menuOptionsButton.setBackgroundImage(
      UIImage(named: Images.toolbarMenuOptions), for: .normal
    )
    menuOptionsButton.setBackgroundImage(
      UIImage(named: Images.toolbarMenuOptions)?.withTintColor(Colors.primaryColor), for: .selected
    )
    
    menuOptionsButton.addTarget(self, action: #selector(menuOptionsDidTapped), for: .touchUpInside)
  }
  
  func layout() {
    addToView(
      backArrowButton, avatarImageView, userNameLabel, userMemberLabel, menuOptionsButton
    )
    
    activatedWithConstraint([
      backArrowButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      backArrowButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimens.smaller),
      backArrowButton.widthAnchor.constraint(equalToConstant: Images.backArrowSize),
      backArrowButton.heightAnchor.constraint(equalToConstant: Dimens.smaller),
      
      avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      avatarImageView.leadingAnchor.constraint(equalTo: backArrowButton.trailingAnchor, constant: Dimens.smaller),
      avatarImageView.widthAnchor.constraint(equalToConstant: Images.avatarSize),
      avatarImageView.heightAnchor.constraint(equalToConstant: Images.avatarSize),
      
      userNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -((Fonts.toolbarTitleSize/2) + 2)),
      userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Dimens.smallest),
      userNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: menuOptionsButton.leadingAnchor, constant: Dimens.smaller),
      
      userMemberLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: (Fonts.toolbarSubtitleSize/2) + 2),
      userMemberLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Dimens.smallest),
      userMemberLabel.trailingAnchor.constraint(lessThanOrEqualTo: menuOptionsButton.trailingAnchor, constant: Dimens.smaller),
      
      menuOptionsButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      menuOptionsButton.widthAnchor.constraint(equalToConstant: Dimens.medium),
      trailingAnchor.constraint(equalTo: menuOptionsButton.trailingAnchor, constant: Dimens.smaller)
    ])
  }
}

// MARK: - Action
extension ChatToolbarView {
  
  @objc func backArrowButtonDidTapped() {
    delegate?.backArrowButtonDidTapped()
  }
  
  @objc func menuOptionsDidTapped() {
    setMenuOptionsButton()
    delegate?.menuOptionsDidTapped()
  }
  
}

// MARK: - handle Uilogic
extension ChatToolbarView {
  
  func setMenuOptionsButton() {
    if !menuOptionsButton.isSelected {
      menuOptionsButton.backgroundColor = .white
    } else {
      menuOptionsButton.backgroundColor = .clear
    }
    
    menuOptionsButton.isSelected = !menuOptionsButton.isSelected
  }
  
}

protocol ChatToolbarViewDelegate {
  func backArrowButtonDidTapped()
  
  func menuOptionsDidTapped()
}
