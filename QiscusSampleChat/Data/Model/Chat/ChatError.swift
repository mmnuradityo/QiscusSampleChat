//
//  ChatError.swift
//  QiscusSampleChat
//
//  Created by Admin on 27/04/24.
//

import Foundation

enum ChatError: LocalizedError, Equatable {
  case invalidLoadRoom
  case invalidEmptyUploadFile
  case custom(message: String)
  
  // MARK: - CutomErrorMessage
  var errorDescription: String? {
    switch self {
    case .custom(let message):
      return message
    case .invalidEmptyUploadFile:
      return "Invalid upload file because file request is empty"
    default:
      return ""
    }
  }
}
