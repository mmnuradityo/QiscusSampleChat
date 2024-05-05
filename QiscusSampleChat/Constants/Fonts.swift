//
//  Fonts.swift
//  QiscusSampleChat
//
//  Created by Admin on 24/04/24.
//

import Foundation

struct Fonts {
  static let interRegular = "Inter-Regular"
  static let interSemiBold = "Inter-SemiBold"
  static let interMedium = "Inter-Medium"
  
  static let toolbarTitleSize: CGFloat = 16
  static let toolbarSubtitleSize: CGFloat = 14
  static let formSize: CGFloat = 14
  static let defaultSize: CGFloat = 12
  static let roomTimeSize: CGFloat = 10
  static let descriptionChatSize: CGFloat = 10
  static let roomListNameSize: CGFloat = 16
  static let timeChatMinWidth: CGFloat = setWidthBasedOnMaxCharacterCount(5, fontSize: Fonts.defaultSize)
  
  static func setWidthBasedOnMaxCharacterCount(_ maxCharacterCount: Int, fontSize: CGFloat) -> CGFloat {
    let averageCharacterWidth: CGFloat = fontSize * 0.6 // You can adjust this value as needed
    let width = averageCharacterWidth * CGFloat(maxCharacterCount)
    return width
  }
}
