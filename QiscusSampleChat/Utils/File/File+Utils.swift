//
//  File+Utils.swift
//  QiscusSampleChat
//
//  Created by Admin on 05/05/24.
//

import UIKit
import QiscusCore
import Photos
import AVFoundation
import UniformTypeIdentifiers

// MARK: ~ handle root directory file
class FileUtils: FileUtilsRootProtocol {
  
  static var fileManager: FileManager = FileManager.default
  static var imagesURL: URL = generateLocalURL(for: .documentDirectory, with: "Images")
  static var videosURL: URL = generateLocalURL(for: .documentDirectory, with: "Videos")
  static var documentsURL: URL = generateLocalURL(for: .documentDirectory, with: "Documents")
  
  static let fileByteCountFormatter: ByteCountFormatter = {
    let bcf = ByteCountFormatter()
    bcf.allowedUnits = [.useMB, .useKB]
    bcf.countStyle = .file
    return bcf
  }()
  
  static func generateLocalURL(for directory: FileManager.SearchPathDirectory, with directoryName: String) -> URL {
    let rootDiredctoryUrl = fileManager.urls(for: directory, in: .userDomainMask)[0]
    let diredctoryUrl = rootDiredctoryUrl.appendingPathComponent(directoryName)
    
    if fileManager.fileExists(atPath: diredctoryUrl.absoluteString) {
      return diredctoryUrl
    }
    
    do {
      try fileManager.createDirectory(
        at: diredctoryUrl, withIntermediateDirectories: true, attributes: nil
      )
      return diredctoryUrl
    } catch {
      return rootDiredctoryUrl
    }
  }
  
  static func isExist(atPath path: String) -> Bool {
    return fileManager.fileExists(atPath: path)
  }
  
}

// MARK: ~ handle base file properties
extension FileUtils: FileUtilsManagementProtocol {
  
  static func generateType(from stringUrl: String) -> MessageType {
    switch fileExtension(from: stringUrl) {
    case "jpg", "png", "heic", "jpeg", "tif", "gif":
      return .image
    case "mp4", "3gp", "mov", "mkv", "webm":
      return .video
    case "doc", "docx", "xls", "xlsx", "ppt", "pptx", "csv", "pdf",
      "txt", "rtf", "odt", "ods", "odp", "odg", "odf", "odm", "ott":
      return .file
    default:
      return .unknown
    }
  }
  
  static func fileExtension(from stringUrl: String) -> String {
    var ext = ""
    
    if stringUrl.range(of: ".") != nil{
      let fileNameArr = stringUrl.split(separator: ".")
      ext = String(fileNameArr.last!).lowercased()
      if ext.contains("?"){
        let newArr = ext.split(separator: "?")
        ext = String(newArr.first!).lowercased()
      }
    }
    
    return ext.lowercased()
  }
  
  static func fileName(from stringUrl: String) -> String {
    let components = stringUrl.split(separator: "/")
    return components.last.map(String.init) ?? ""
  }
  
  static func getFileSize(atPath path: String) -> String {
    do {
      let attributes = try FileUtils.fileManager.attributesOfItem(atPath: path)
      if let fileSize = attributes[.size] as? Int64 {
        let fileSizeFormatted = FileUtils.fileByteCountFormatter.string(
          fromByteCount: fileSize
        )
        return fileSizeFormatted
      } else {
        return "0 byte"
      }
    } catch {
      return "0 byte"
    }
  }
  
  // MARK: ~ handle file management
  
  static func getDestinationURLByExtention(from fileNameWithExtension: String) -> URL {
    switch generateType(from: fileNameWithExtension) {
    case .image:
      return imagesURL.appendingPathComponent(fileNameWithExtension)
    case .video:
      return videosURL.appendingPathComponent(fileNameWithExtension)
    case .file:
      return documentsURL.appendingPathComponent(fileNameWithExtension)
    default:
      return fileManager.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
        .appendingPathComponent(fileNameWithExtension)
    }
  }
  
  static func fileExistsWithURL(fileNameWithExtension: String) -> URL? {
    let destinationURL = getDestinationURLByExtention(from: fileNameWithExtension)
    if isExist(atPath: destinationURL.path) {
      return destinationURL
    }
    return nil
  }
  
  static func save(tempLocalUrl: URL, completion: @escaping (URL?, FileError?) -> Void) {
    do {
      let destinationURL = getDestinationURLByExtention(from: tempLocalUrl.lastPathComponent)
      try fileManager.moveItem(at: tempLocalUrl, to: destinationURL)
      completion(destinationURL, nil)
    } catch {
      completion(nil, FileError.custom(message: error.localizedDescription))
    }
  }
  
  // MARK: ~ handle Images
  
  static func saveImageToGallery(imageURL: URL, completion: @escaping (FileError?) -> Void) {
    do {
      let imageData = try Data(contentsOf: imageURL)
      saveImageToGallery(imageData: imageData, completion: completion)
    } catch {
      completion(FileError.custom(message: error.localizedDescription))
    }
  }
  
  static func saveImageToGallery(imageData: Data, completion: @escaping (FileError?) -> Void) {
    PHPhotoLibrary.shared().performChanges({
      let creationRequest = PHAssetCreationRequest.forAsset()
      creationRequest.addResource(with: .photo, data: imageData, options: nil)
    }) { (success, error) in
      if let error = error {
        completion(FileError.custom(message: error.localizedDescription))
      } else {
        completion(nil)
      }
    }
  }
  
  // MARK: ~ handle Videos
  
  static func saveVideoToGallery(
    videoURL: URL, albumName: String, completion: @escaping (FileError?) -> Void
  ) {
    if albumExists(albumName: albumName) {
      let fetchOptions = PHFetchOptions()
      fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
      let collection = PHAssetCollection.fetchAssetCollections(
        with: .album, subtype: .any, options: fetchOptions
      )
      
      if let album = collection.firstObject {
        saveVideo(videoURL: videoURL, to: album, completion: completion)
      }
    } else {
      var albumPlaceholder: PHObjectPlaceholder?
      PHPhotoLibrary.shared().performChanges({
        let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
        albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
      }, completionHandler: { success, error in
        if success {
          guard let albumPlaceholder = albumPlaceholder else { return }
          let collectionFetchResult = PHAssetCollection.fetchAssetCollections(
            withLocalIdentifiers: [albumPlaceholder.localIdentifier], options: nil
          )
          guard let album = collectionFetchResult.firstObject else { return }
          
          self.saveVideo(videoURL: videoURL, to: album, completion: completion)
          
        } else if let error = error {
          completion(FileError.custom(message: error.localizedDescription))
        }
      })
    }
  }
  
  internal static func albumExists(albumName: String) -> Bool {
    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
    let collection = PHAssetCollection.fetchAssetCollections(
      with: .album, subtype: .any, options: fetchOptions
    )
    return collection.firstObject != nil
  }
  
  internal static func saveVideo(
    videoURL: URL, to album: PHAssetCollection, completion: @escaping (FileError?) -> Void
  ) {
    PHPhotoLibrary.shared().performChanges({
      let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
      let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
      let enumeration: NSArray = [assetChangeRequest!.placeholderForCreatedAsset!]
      albumChangeRequest?.addAssets(enumeration)
    }, completionHandler: { success, error in
      if let error = error {
        completion(FileError.custom(message: error.localizedDescription))
      } else {
        completion(nil)
      }
    })
  }
  
}
