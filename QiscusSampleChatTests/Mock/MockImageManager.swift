//
//  MockImageManager.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 29/04/24.
//

import Foundation
import AVFoundation
@testable import QiscusSampleChat

class MockImageManager: ThumbnailManagerProtocol {
  
  var data: Data?
  var videoDuration: CMTime?
  
  func loadThumbnailVideo(url: URL?, completion: @escaping (Data?, CMTime?, QiscusSampleChat.ImageModel.State) -> Void) {
    completion(data, videoDuration, data == nil ? .failed : .success)
  }
  
  func loadThumbnailImage(url: URL?, completion: @escaping (Data?, QiscusSampleChat.ImageModel.State) -> Void) {
    completion(data, data == nil ? .failed : .success)
  }
  
}
