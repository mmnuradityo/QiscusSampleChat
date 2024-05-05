//
//  MessageType.swift
//  QiscusSampleChat
//
//  Created by Admin on 29/04/24.
//

import Foundation


enum MessageType: String {
  case text
  case image
  case video
  case file
  case unknown
  
  func toString() -> String {
    switch self {
    case .text:
      return "text"
    case .image, .video, .file:
      return "file_attachment"
    case .unknown:
      return "unknown"
    }
  }
}
