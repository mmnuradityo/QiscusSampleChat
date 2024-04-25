//
//  ChatFormView.swift
//  QiscusSampleChat
//
//  Created by Admin on 25/04/24.
//

import UIKit

class ChatFormView: BaseCustomView {
  
  let menuButton = UIButton()
  let formTextView = UITextView()
  let sendButton = UIButton()
  
  let formPlaceholder = "Send a message..."
  var delegate: ChatFormViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    style()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIView.noIntrinsicMetric, height: Dimens.chatFormHeight)
  }
}

extension ChatFormView {
  
  func style() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = Colors.chatFormBackgroundColor
    
    menuButton.translatesAutoresizingMaskIntoConstraints = false
    menuButton.setBackgroundImage(
      UIImage(named: Images.chatFormMenu), for: .normal
    )
    menuButton.addTarget(self, action: #selector(menuButtonDidTapped), for: .touchUpInside)
    
    formTextView.translatesAutoresizingMaskIntoConstraints = false
    formTextView.makeFormStyle(
      identifier: "formTextField", placeholder: formPlaceholder
    )
    formTextView.autocorrectionType = .no
    formTextView.autocapitalizationType = .none
    formTextView.isEditable = true
    formTextView.isScrollEnabled = true
    formTextView.delegate = self
    
    sendButton.translatesAutoresizingMaskIntoConstraints = false
    sendButton.setBackgroundImage(
      UIImage(named: Images.chatFormSend), for: .normal
    )
    sendButton.addTarget(self, action: #selector(sendButtonDidTapped), for: .touchUpInside)
  }
  
  func layout() {
    addToView(menuButton, formTextView, sendButton)
    
    activatedWithConstrain([
      menuButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimens.paddingChatIcon),
      menuButton.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: Dimens.paddingChatIcon),
      menuButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimens.small),
      menuButton.widthAnchor.constraint(equalToConstant: Images.iconSize),
      menuButton.heightAnchor.constraint(equalToConstant: Images.iconSize),
      
      formTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimens.smaller),
      formTextView.topAnchor.constraint(equalTo: topAnchor, constant: Dimens.smaller),
      formTextView.leadingAnchor.constraint(equalTo: menuButton.trailingAnchor, constant: Dimens.small),
      formTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -Dimens.small),
      formTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: Dimens.formHeight),
      
      sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimens.paddingChatIcon),
      sendButton.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: Dimens.paddingChatIcon),
      trailingAnchor.constraint(equalTo: sendButton.trailingAnchor, constant: Dimens.small),
      sendButton.widthAnchor.constraint(equalToConstant: Images.iconSize),
      sendButton.heightAnchor.constraint(equalToConstant: Images.iconSize),
    ])
  }
}

// MARK: ~ handle action UITextViewDelegate
extension ChatFormView: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    textView.setPlaceHolder(placeholder: formPlaceholder)
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    textView.setPlaceHolder(placeholder: formPlaceholder)
  }
  
  func textViewDidChange(_ textView: UITextView) {
    let size = CGSize(width: textView.frame.size.width, height: textView.frame.size.height)
    let estimateSize = textView.sizeThatFits(size)
    
    guard textView.contentSize.height < 70.0 else {
      textView.isScrollEnabled = true
      return
    }
    
    textView.isScrollEnabled = false
    textView.constraints.forEach { constraint in
      if constraint.firstAttribute == .height {
        constraint.constant = estimateSize.height
      }
    }
  }
  
}

// MARK: ~ handle action
extension ChatFormView {
  @objc func menuButtonDidTapped() {
    delegate?.menuButtonDidTapped()
  }
  
  @objc func sendButtonDidTapped() {
    delegate?.sendButtonDidTapped()
  }
}

// MARK: ~ Action
protocol ChatFormViewDelegate {
  func menuButtonDidTapped()
  
  func sendButtonDidTapped()
}
