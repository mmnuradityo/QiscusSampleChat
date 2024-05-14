//
//  MockThumbnailManager.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 15/05/24.
//

import Foundation
import AVFoundation
@testable import QiscusSampleChat

class MockThumbnailManager: ThumbnailManagerProtocol {
  
  var imagedata: Data?
  var duration: CMTime?
  var imageState: ImageModel.State = .new
  
  func loadThumbnailVideo(url: URL?, completion: @escaping (Data?, CMTime?, ImageModel.State) -> Void) {
    completion(imagedata, duration, imageState)
  }
  
  func loadThumbnailImage(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void) {
    completion(imagedata, imageState)
  }
  
}
