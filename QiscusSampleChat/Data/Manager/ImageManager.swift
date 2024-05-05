//
//  ImageManager.swift
//  QiscusSampleChat
//
//  Created by Admin on 28/04/24.
//

import MobileCoreServices
import AVFoundation

protocol ImageManagerProtocol {
  func loadThumbnailVideo(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void)
  func loadThumbnailImage(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void)
}

class ImageManager: ImageManagerProtocol {
  
  func loadThumbnailVideo(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void) {
    Task {
      do {
        if let url = url {
          if !FileManager.default.fileExists(atPath: url.path) {
            completion(nil, .loading)
          }
          
          let asset: AVAsset = AVAsset(url: url)
          let imageGenerator = AVAssetImageGenerator(asset: asset)
            
          async let thumbnailImage = try imageGenerator.copyCGImage(
            at: CMTimeMake(value: 1, timescale: 60), actualTime: nil
          )
          
          let dataImage = convertCGImageToNSData(
            image: try await thumbnailImage, type: UTType.png
          )
          completion(dataImage, .success)
          return
        }
      } catch {
        // don nothings
      }
      
      completion(nil, .failed)
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
          if !FileManager.default.fileExists(atPath: url.path) {
            completion(nil, .loading)
          }
          
          async let imageData: Data = try Data(contentsOf: url)
          completion(try await imageData, .success)
          return
        }
      } catch {
        // don nothings
      }
      
      completion(nil, .failed)
    }
  }
  
}
