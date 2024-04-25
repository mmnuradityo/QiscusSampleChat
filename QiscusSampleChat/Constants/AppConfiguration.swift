//
//  Constants.swift
//  QiscusSampleChat
//
//  Created by Admin on 22/04/24.
//

import Foundation

struct AppConfiguration {
  static let APP_ID = Bundle.main.object(forInfoDictionaryKey: "APP_ID") as? String
}
