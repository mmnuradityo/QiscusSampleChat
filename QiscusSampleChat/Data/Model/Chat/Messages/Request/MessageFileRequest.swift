//
//  MessageFileRequest.swift
//  QiscusSampleChat
//
//  Created by Admin on 01/05/24.
//

import Foundation

struct MessageFileRequest {
  let data: Data?
  let url: URL?
  let name: String
  let caption: String
  
  init(data: Data?, url: URL?, name: String = "", caption: String = "") {
    self.data = data
    self.url = url
    self.name = name
    self.caption = caption
  }
}
