//
//  Alert+Utils.swift
//  QiscusSampleChat
//
//  Created by Admin on 22/04/24.
//

import UIKit

class AlertUtils {
  static let identifierInfo = "infoAlertDialog"
  static let identifierSuccess = "successAlertDialog"
  static let identifierError = "errorAlertDialog"

  static func alertDialog(
    title: String, message: String, identifier: String, handler: ((UIAlertAction) -> Void)? = nil
  ) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
    alert.view.accessibilityIdentifier = identifier
    return alert
  }
  
}
