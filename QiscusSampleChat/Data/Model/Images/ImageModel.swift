//
//  ImageModel.swift
//  QiscusSampleChat
//
//  Created by Admin on 28/04/24.
//

import Foundation

struct ImageModel {
  
  var url: URL?
  var data: Data?
  var state: State
  
  init(url: URL?, data: Data? = nil, state: State = .new) {
    self.url = url
    self.data = data
    self.state = state
  }
  
  mutating func createThumbnailURL() {
    let imageUrl = url?.absoluteString ?? ""
    if imageUrl.isEmpty{ return }
    
    let thumbURL = imageUrl.replacingOccurrences(of: "/upload/", with: "/upload/w_320,h_320,c_limit/").replacingOccurrences(of: " ", with: "%20")
    let thumbUrlArr = thumbURL.split(separator: ".")
    
    var newThumbURL = ""
    var i = 0
    for thumbComponent in thumbUrlArr{
      if i == 0{
        newThumbURL += String(thumbComponent)
      }else if i < (thumbUrlArr.count - 1){
        newThumbURL += ".\(String(thumbComponent))"
      }else{
        newThumbURL += ".png"
      }
      i += 1
    }
    
    self.url = URL(string: newThumbURL)
  }
  
  enum State {
    case new
    case loading
    case success
    case failed
  }
}
