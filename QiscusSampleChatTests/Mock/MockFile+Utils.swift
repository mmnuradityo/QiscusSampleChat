//
//  MockFile+Utils.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 14/05/24.
//

import Foundation
@testable import QiscusSampleChat
import Photos

class MockFileUtils: FileUtilsManagementProtocol {
  
  static var messageType: MessageType = .file
  static var localUrl: URL?
  static var localUrlExist: URL?
  static var error: FileError?
  static var mediaError: FileError?
  
  static func generateType(from stringUrl: String) -> MessageType {
    // do nothings
    return messageType
  }
  
  static func fileExtension(from stringUrl: String) -> String {
    // do nothings
    return ""
  }
  
  static func fileName(from stringUrl: String) -> String {
    // do nothings
    return ""
  }
  
  static func getFileSize(atPath path: String) -> String {
    // do nothings
    return ""
  }
  
  static func getDestinationURLByExtention(from fileNameWithExtension: String) -> URL {
    // do nothings
    return URL(string: "")!
  }
  
  static func fileExistsWithURL(fileNameWithExtension: String) -> URL? {
    // do nothings
    return localUrlExist
  }
  
  static func save(tempLocalUrl: URL, completion: @escaping (URL?, FileError?) -> Void) {
    if let error = error {
      completion(nil, error)
    } else if let localUrl = localUrl {
      completion(localUrl, nil)
    }
  }
  
  static func saveImageToGallery(imageURL: URL, completion: @escaping (FileError?) -> Void) {
    completion(mediaError)
  }
  
  static func saveImageToGallery(imageData: Data, completion: @escaping (FileError?) -> Void) {
    // do nothings
  }
  
  static func saveVideoToGallery(videoURL: URL, albumName: String, completion: @escaping (FileError?) -> Void) {
    completion(mediaError)
  }
  
  static func albumExists(albumName: String) -> Bool {
    // do nothings
    return false
  }
  
  static func saveVideo(videoURL: URL, to album: PHAssetCollection, completion: @escaping (FileError?) -> Void) {
    // do nothings
  }
  
  
}
