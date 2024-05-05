//
//  MessageDataModel.swift
//  QiscusSampleChat
//
//  Created by Admin on 27/04/24.
//

import Foundation

struct MessageDataModel {
  
  let dataType: MessageType
  let fileName: String
  let url: URL?
  let caption: String
  
  var _isDownloaded: Bool = false
  private var _previewImage: ImageModel?
  
  var isDownloaded: Bool {
    get {
      return self._isDownloaded
    }
    set {
      let isPosibleType = self.dataType == .image
      || self.dataType == .video
      || self.dataType == .file
      
      self._isDownloaded = isPosibleType && newValue
    }
  }
  
  var previewImage: ImageModel? {
    get {
      if self.dataType == .image || self.dataType == .video {
        if self._previewImage != nil {
          return self._previewImage
        } else {
          var imageUrl = ImageModel(url: self.url)
          imageUrl.createThumbnailURL()
          return imageUrl
        }
      }
      
      return nil
    }
    set {
      if self.dataType == .image {
        self._previewImage = newValue
      }
    }
  }
  
  init(dataType: MessageType, fileName: String, url: String, caption: String) {
    self.dataType = dataType
    self.fileName = fileName
    self.url = URL(string: url)
    self.caption = caption
  }
  
}

enum MessageDataParams: String {
  case fileName = "file_name"
  case url = "url"
  case caption = "caption"
}
