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
  let caption: String
  var url: URL?
  
  var _isDownloaded: Bool
  private var _previewImage: ImageModel?
  
  var isDownloaded: Bool {
    get {
      return self._isDownloaded
    }
    set {
      self._isDownloaded = newValue
    }
  }
  
  var previewImage: ImageModel? {
    get {
      if (self.dataType == .image
          && self._previewImage != nil)
          && self._previewImage != nil {
        return self._previewImage
      } else {
        var imageUrl = ImageModel(url: self.url)
        if self.dataType == .image {
          imageUrl.createThumbnailURL()
        }
        return imageUrl
      }
    }
    set {
      self._previewImage = newValue
    }
  }
  
  init(dataType: MessageType, fileName: String, url: String, caption: String, isDownloaded: Bool = false) {
    self.dataType = dataType
    self.fileName = fileName
    self.url = URL(string: url)
    self.caption = caption
    self._isDownloaded = isDownloaded
  }
  
}

enum MessageDataParams: String {
  case fileName = "file_name"
  case url = "url"
  case caption = "caption"
}
