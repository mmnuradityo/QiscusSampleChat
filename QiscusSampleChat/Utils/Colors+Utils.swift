//
//  Color+Utils.swift
//  QiscusSampleChat
//
//  Created by Admin on 22/04/24.
//

import UIKit

struct Colors {
  static let primaryColor = UIColor(hex: "#27B199")
  static let strokeColor = UIColor(hex: "#E3E3E3")
  static let chatFormBackgroundColor = UIColor(hex: "#FAFAFA")
  static let textFormColor = UIColor(hex: "#B9B9B9")
  
}

extension UIColor {
  convenience init(hex: String, alpha: CGFloat = 1.0) {
          var hexValue = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

          if hexValue.hasPrefix("#") {
              hexValue.remove(at: hexValue.startIndex)
          }

          var rgbValue: UInt64 = 0
          Scanner(string: hexValue).scanHexInt64(&rgbValue)

          let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
          let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
          let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

          self.init(red: red, green: green, blue: blue, alpha: alpha)
      }
}
