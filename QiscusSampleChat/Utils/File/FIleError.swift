//
//  FIleError.swift
//  QiscusSampleChat
//
//  Created by Admin on 14/05/24.
//

import Foundation

enum FileError: LocalizedError, Equatable {
  case emptyData
  case failed
  case custom(message: String)
  
  var description: String {
    switch self {
    case .emptyData:
      return "Empty Data"
    case .failed:
      return "Failed"
    case .custom(let message):
      return message
    }
  }
}
