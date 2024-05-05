//
//  ChatDateView.swift
//  QiscusSampleChat
//
//  Created by Admin on 28/04/24.
//

import UIKit

class ChatDateView: BaseCustomView {
  
  let dateTimeChatLabel = TextLabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    style()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var intrinsicContentSize: CGSize {
    return  CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
  }
  
}

// MARK: - setup and layouting
extension ChatDateView {
  
  func style() {
    translatesAutoresizingMaskIntoConstraints = false
    
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
    dateTimeChatLabel.backgroundColor = Colors.datetTimeChatBackgroundColor
  }
  
  func layout() {
    addToView(dateTimeChatLabel)
    
    activatedWithConstraint([
      dateTimeChatLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      dateTimeChatLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
    ])
  }
}
