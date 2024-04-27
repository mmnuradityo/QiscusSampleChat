//
//  MessageDataModel.swift
//  QiscusSampleChat
//
//  Created by Admin on 27/04/24.
//

import Foundation

struct MessageDataModel {
  
  let dataType: DataType
  let fileName: String
  let url: URL?
  let caption: String
  
  init(dataType: DataType, fileName: String, url: String, caption: String) {
    self.dataType = dataType
    self.fileName = fileName
    self.url = URL(string: url)
    self.caption = caption
  }
  
  enum DataType {
    case text
    case image
    case video
    case file
    case unknown
  }
}

