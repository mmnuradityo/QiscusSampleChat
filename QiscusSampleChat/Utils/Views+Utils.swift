//
//  View+Utils.swift
//  QisusSampleChat
//
//  Created by Admin on 22/04/24.
//

import UIKit

extension UITextField {
  
  func makeFormStyle(placeholder: String) {
    self.placeholder = placeholder
    self.layer.cornerRadius = 8
    self.layer.borderWidth = 1
    self.layer.borderColor = Colors.strokeColor.cgColor
    self.setPadding(start: 16, end: 16)
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
  
  func makeButtonStyle(title: String) {
    self.setTitle(title, for: .normal)
    self.setTitleColor(.white, for: .normal)
    self.clipsToBounds = true
    self.layer.masksToBounds = true
    self.layer.cornerRadius = 18
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
  
}
