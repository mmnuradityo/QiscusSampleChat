//
//  ImageManager.swift
//  QiscusSampleChat
//
//  Created by Admin on 28/04/24.
//

import MobileCoreServices
import AVFoundation

protocol ThumbnailManagerProtocol {
  func loadThumbnailVideo(url: URL?, completion: @escaping (Data?, CMTime?, ImageModel.State) -> Void)
  func loadThumbnailImage(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void)
}

class ThumbnailManager: ThumbnailManagerProtocol {
  
  var thumbnailCache = NSCache<NSString, ImageCache>()
  
  func loadThumbnailCache(key: String) -> ImageCache? {
    return thumbnailCache.object(forKey: key as NSString)
  }
  
  func saveThumbnailCache(
    _ key: String, dataImage: Data?, duration: CMTime?, state: ImageModel.State
  ) {
    var extras: [String: Any] = [:]
    if duration != nil {
      extras[MessageDataExtraParams.duration.rawValue] = duration
    }
    extras[MessageDataExtraParams.state.rawValue] = ImageModel.State.success
    
    let imageCache = ImageCache(data: dataImage!, extras: extras)
    thumbnailCache.setObject(imageCache, forKey: key as NSString)
  }
  
  func loadThumbnailVideo(url: URL?, completion: @escaping (Data?, CMTime?, ImageModel.State) -> Void) {
    Task {
      do {
        if let url = url {
          if let imageCache = loadThumbnailCache(key: url.absoluteString),
             let state = imageCache.extras[MessageDataExtraParams.state.rawValue] as? ImageModel.State,
             let duration = imageCache.extras[MessageDataExtraParams.duration.rawValue] as? CMTime,
             state == .success {
            completion(imageCache.data, duration, state)
            return
          }
          
          let asset: AVAsset = AVAsset(url: url)
          let imageGenerator = AVAssetImageGenerator(asset: asset)
          imageGenerator.appliesPreferredTrackTransform = true
          
          async let thumbnailImage = try imageGenerator.copyCGImage(
            at:.zero, actualTime: nil
          )
          
          let dataImage = convertCGImageToNSData(
            image: try await thumbnailImage, type: UTType.png
          )
          let duration = try await asset.load(.duration)
          
          if dataImage != nil {
            saveThumbnailCache(
              url.absoluteString, dataImage: dataImage, duration: duration, state: .success
            )
          }
          completion(dataImage, duration, .success)
          return
        }
      } catch {
        // do nothings
      }
      
      completion(nil, nil, .failed)
    }
  }
  
  func convertCGImageToNSData(image: CGImage, type: UTType) -> Data? {
    let imageData = NSMutableData()
    guard let destination = CGImageDestinationCreateWithData(imageData, type.identifier as CFString, 1, nil) else {
      return nil
    }
    CGImageDestinationAddImage(destination, image, nil)
    
    if !CGImageDestinationFinalize(destination) {
      return nil
    }
    return imageData as Data
  }
  
  func loadThumbnailImage(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void) {
    Task {
      do {
        if let url = url {
          if let imageCache = loadThumbnailCache(key: url.absoluteString),
             let state = imageCache.extras[MessageDataExtraParams.state.rawValue] as? ImageModel.State,
             state == .success {
            completion(imageCache.data, state)
            return
          }
          
          async let imageData: Data = try Data(contentsOf: url)
          let dataImage = try await imageData
          
          saveThumbnailCache(
            url.absoluteString, dataImage: dataImage, duration: nil, state: .success
          )
          completion(dataImage, .success)
          return
        }
      } catch {
        // do nothings
      }
      
      completion(nil, .failed)
    }
  }
  
}

class ImageCache {
  let data: Data
  let extras: [String: Any]
  
  init(data: Data, extras: [String: Any]) {
    self.data = data
    self.extras = extras
  }
}
