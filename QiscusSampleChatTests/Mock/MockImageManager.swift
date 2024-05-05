//
//  MockImageManager.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 29/04/24.
//

import Foundation
@testable import QiscusSampleChat

class MockImageManager: ImageManagerProtocol {
  
  var data: Data?
  
  func loadThumbnailVideo(url: URL?, completion: @escaping (Data?, QiscusSampleChat.ImageModel.State) -> Void) {
    completion(data, data == nil ? .failed : .success)
  }
  
  func loadThumbnailImage(url: URL?, completion: @escaping (Data?, QiscusSampleChat.ImageModel.State) -> Void) {
    completion(data, data == nil ? .failed : .success)
  }
  
}
