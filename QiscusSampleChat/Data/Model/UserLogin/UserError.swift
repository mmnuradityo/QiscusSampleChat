//
//  UserError.swift
//  QiscusSampleChat
//
//  Created by Admin on 23/04/24.
//

import Foundation

enum UserError: LocalizedError, Equatable {
  case invalidSaveUser
  case invalidClearUser
  case custom(message: String)
  
  // MARK: - CutomErrorMessage
  var errorDescription: String? {
    switch self {
    case .invalidSaveUser:
      return "Invalid save user"
    case .invalidClearUser:
      return "Invalid clear user"
    case .custom(let message):
      return message
    }
  }
}
