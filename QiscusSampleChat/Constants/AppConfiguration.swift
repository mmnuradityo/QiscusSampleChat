//
//  Constants.swift
//  QiscusSampleChat
//
//  Created by Admin on 22/04/24.
//

import Foundation
import UniformTypeIdentifiers

struct AppConfiguration {
  static let APP_ID = Bundle.main.object(forInfoDictionaryKey: "APP_ID") as? String
//  static let SAMPLE_ROOM_ID = "187190115"
  static let SAMPLE_ROOM_ID = "185063351"
  
  private static var userEmail: String?
  
  static func isMyMessage(senderEmail: String) -> Bool {
    if userEmail == nil {
      userEmail = AppComponent.shared.getDataStore().getUserLocalDateBase().getUser()?.email
    }
    if let userEmail = userEmail {
      return userEmail == senderEmail
    }
    return false
  }
}

extension UTType {
  static var txt: UTType = UTType(importedAs: "com.qiscus.plain-text.txt")
}
