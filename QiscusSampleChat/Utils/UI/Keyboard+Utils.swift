//
//  Keyboard+Utils.swift
//  QiscusSampleChat
//
//  Created by Admin on 25/04/24.
//

import UIKit

// MARK: Keyboard
class KeyboardUtils {
  
  static func setupKeyboradShowingOrHidding(
    _ observer: Any, willShowSelector aWillShowSelector: Selector, willHideSelector aWillHideSelector: Selector
  ) {
    NotificationCenter.default.addObserver(
      observer, selector: aWillShowSelector, name: UIResponder.keyboardWillShowNotification, object: nil
    )
    NotificationCenter.default.addObserver(
      observer, selector: aWillHideSelector, name: UIResponder.keyboardWillHideNotification, object: nil
    )
  }
  
 static func removeObserver(_ observer: Any) {
    NotificationCenter.default.removeObserver(observer)
  }
}

extension UIResponder {
  
  private struct Static {
    static weak var responder: UIResponder?
  }
  
  /// Finds the current first responder
  /// - Returns: the current UIResponder if it exists
  static func currentFirst() -> UIResponder? {
    Static.responder = nil
    UIApplication.shared.sendAction(
      #selector(UIResponder._trap), to: nil, from: nil, for: nil
    )
    return Static.responder
  }
  
  @objc func _trap() {
    Static.responder = self
  }
}
