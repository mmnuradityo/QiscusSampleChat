//
//  View+Utils.swift
//  QiscusSampleChat
//
//  Created by Admin on 22/04/24.
//

import UIKit

class TextLabel: UILabel  {
  
  private var topInset = CGFloat(0)
  private var bottomInset = CGFloat(0)
  private var leftInset = CGFloat(0)
  private var rightInset = CGFloat(0)
  
  func setPadding(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
    topInset = top
    bottomInset = bottom
    leftInset = left
    rightInset = right
  }
  
  override func drawText(in rect: CGRect) {
    let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    super.drawText(in: rect.inset(by: insets))
  }
  
  override public var intrinsicContentSize: CGSize {
    var intrinsicSuperViewContentSize = super.intrinsicContentSize
    intrinsicSuperViewContentSize.height += topInset + bottomInset
    intrinsicSuperViewContentSize.width += leftInset + rightInset
    return intrinsicSuperViewContentSize
  }
}
  
extension UITextView {
  
  func makeFormStyle(identifier: String, placeholder: String) {
    self.accessibilityIdentifier = identifier
    self.layer.cornerRadius = Dimens.smallest
    self.layer.borderWidth = Dimens.strokeSize
    self.layer.borderColor = Colors.strokeColor.cgColor
    self.textContainerInset = UIEdgeInsets(
      top: Dimens.smallest, left: Dimens.paddingForm,
      bottom: Dimens.smallest, right: Dimens.paddingForm
    )
    self.autocapitalizationType = .none
    self.font = UIFont(
      name: Fonts.interRegular, size: Fonts.formSize
    )
    self.setPlaceHolder(placeholder: placeholder)
  }
  
  func setPlaceHolder(placeholder: String) {
    if self.text.isEmpty {
      self.text = placeholder
      self.textColor = Colors.textFormColor
    } else if self.textColor == Colors.textFormColor {
      self.text = nil
      self.textColor = .black
    }
  }
}

extension UITextField {
  
  func makeFormStyle(identifier: String, placeholder: String) {
    self.accessibilityIdentifier = identifier
    self.placeholder = placeholder
    self.layer.cornerRadius = Dimens.smallest
    self.layer.borderWidth = Dimens.strokeSize
    self.layer.borderColor = Colors.strokeColor.cgColor
    self.setPadding(start: Dimens.paddingForm, end: Dimens.paddingForm)
    self.autocapitalizationType = .none
    self.font = UIFont(
      name: Fonts.interRegular, size: Fonts.formSize
    )
  }
  
  func setPadding(start: CGFloat, end: CGFloat) {
    self.leftView = convertToPadding(amount: start)
    self.rightView = convertToPadding(amount: end)
    self.leftViewMode = .always
    self.rightViewMode = .always
  }
  
  private func convertToPadding(amount:CGFloat) -> UIView {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
    return paddingView
  }
}

extension UIButton {
  
  func makeButtonStyle(identifier: String, title: String) {
    self.accessibilityIdentifier = identifier
    self.setTitle(title, for: .normal)
    self.setTitleColor(.white, for: .normal)
    self.clipsToBounds = true
    self.layer.masksToBounds = true
    self.layer.cornerRadius = Dimens.small
    self.titleLabel?.font = UIFont(
      name: Fonts.interRegular, size: Fonts.defaultSize
    )
    self.setBackgroundColor(
      color: self.isEnabled ? Colors.primaryColor : Colors.strokeColor,
      forState: .normal
    )
  }
  
  func setBackgroundColor(color: UIColor, forState: UIControl.State) {
    UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
    if let context = UIGraphicsGetCurrentContext() {
      context.setFillColor(color.cgColor)
      context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
      let colorImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      self.setBackgroundImage(colorImage, for: forState)
    }
  }
  
  func setupMenuButton(imageIcon: String, title: String) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.setImage(UIImage(named: imageIcon), for: .normal)
    self.setTitle(title, for: .normal)
    self.setTitleColor(.black, for: .normal)
    self.setTitleColor(Colors.primaryColor, for: .highlighted)
    self.titleLabel?.font = UIFont(
      name: Fonts.interRegular, size: Fonts.formSize
    )
    self.setConfigureButton()
  }
  
  func setConfigureButton()  {
    self.configuration = configureButton()
  }
  
  private func configureButton() -> UIButton.Configuration {
    var buttonConfiguration = UIButton.Configuration.borderless()
    buttonConfiguration.imagePadding = Dimens.smaller
    buttonConfiguration.contentInsets = NSDirectionalEdgeInsets(
      top: 0, leading: 0, bottom: 0, trailing: 0
    )
    return buttonConfiguration
  }
}
