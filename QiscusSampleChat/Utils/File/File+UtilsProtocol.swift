//
//  File+UtilsProtocol.swift
//  QiscusSampleChat
//
//  Created by Admin on 14/05/24.
//

import Foundation
import Photos

protocol FileUtilsRootProtocol {
  static func generateLocalURL(for directory: FileManager.SearchPathDirectory, with directoryName: String) -> URL
  static func isExist(atPath path: String) -> Bool
}

protocol FileUtilsManagementProtocol {
  // MARK: ~ handle base file properties
  static func generateType(from stringUrl: String) -> MessageType
  static func fileExtension(from stringUrl: String) -> String
  static func fileName(from stringUrl: String) -> String
  static func getFileSize(atPath path: String) -> String
  // MARK: ~ handle file management
  static func getDestinationURLByExtention(from fileNameWithExtension: String) -> URL
  static func fileExistsWithURL(fileNameWithExtension: String) -> URL?
  static func save(tempLocalUrl: URL, completion: @escaping (URL?, FileError?) -> Void)
  // MARK: ~ handle Images
  static func saveImageToGallery(imageURL: URL, completion: @escaping (FileError?) -> Void)
  static func saveImageToGallery(imageData: Data, completion: @escaping (FileError?) -> Void)
  // MARK: ~ handle Videos
  static func saveVideoToGallery(videoURL: URL, albumName: String, completion: @escaping (FileError?) -> Void)
  static func albumExists(albumName: String) -> Bool
  static func saveVideo(videoURL: URL, to album: PHAssetCollection, completion: @escaping (FileError?) -> Void)
}
