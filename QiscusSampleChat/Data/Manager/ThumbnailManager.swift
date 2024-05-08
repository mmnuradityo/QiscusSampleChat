//
//  ImageManager.swift
//  QiscusSampleChat
//
//  Created by Admin on 28/04/24.
//

import MobileCoreServices
import AVFoundation

protocol ThumbnailManagerProtocol {
  func loadThumbnailVideo(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void)
  func loadThumbnailImage(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void)
}

class ThumbnailManager: ThumbnailManagerProtocol {
  
  func loadThumbnailVideo(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void) {
    Task {
      do {
        if let url = url {
          let asset: AVAsset = AVAsset(url: url)
          let imageGenerator = AVAssetImageGenerator(asset: asset)
          imageGenerator.appliesPreferredTrackTransform = true
          
          async let thumbnailImage = try imageGenerator.copyCGImage(
            at:.zero, actualTime: nil
          )
          
          let dataImage = convertCGImageToNSData(
            image: try await thumbnailImage, type: UTType.png
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
          async let imageData: Data = try Data(contentsOf: url)
          completion(try await imageData, .success)
          return
        }
      } catch {
        // do nothings
      }
      
      completion(nil, .failed)
    }
  }
  
}

