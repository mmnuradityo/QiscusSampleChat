//
//  Constants.swift
//  QiscusSampleChat
//
//  Created by Admin on 22/04/24.
//

import Foundation

struct AppConfiguration {
  
  static let APP_IDENTIFIER = Bundle.main.bundleIdentifier ?? "QiscusApp"
  static let APP_ID = Bundle.main.object(forInfoDictionaryKey: "APP_ID") as? String
  
//  static let SAMPLE_ROOM_ID = "187190115"
//  static let SAMPLE_ROOM_ID = "185063351"
  
  static var userEmail: String?
  
  static func isMyMessage(
    senderEmail: String,
    userLocal: UserLocalDateBaseProtocol? = AppComponent.shared.getDataStore().getUserLocalDateBase()
  ) -> Bool {
    if userEmail == nil {
      userEmail = userLocal?.getUser()?.email
    }
    if let userEmail = userEmail {
      return userEmail == senderEmail
    }
    return false
  }
}
