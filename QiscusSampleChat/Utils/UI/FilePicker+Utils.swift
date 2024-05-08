//
//  FilePicker+Utils.swift
//  QiscusSampleChat
//
//  Created by Admin on 30/04/24.
//

import UIKit
import UniformTypeIdentifiers

class FilePickerUtils {
  
  var delegate: FilePickerDelegate?
  
  var imagePicker: UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self.delegate
    imagePicker.allowsEditing = true
    imagePicker.sourceType = .photoLibrary
    imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
    imagePicker.modalPresentationStyle = .fullScreen
    return imagePicker
  }
  
  var cameraPicker: UIImagePickerController {
    let cameraPicker = UIImagePickerController()
    cameraPicker.delegate = self.delegate
    cameraPicker.allowsEditing = true
    cameraPicker.sourceType = .camera
    cameraPicker.modalPresentationStyle = .fullScreen
    return cameraPicker
  }
  
  var documentPicker: UIDocumentPickerViewController {
    let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .txt], asCopy: true)
    documentPicker.delegate = self.delegate
    documentPicker.modalPresentationStyle = .fullScreen
    return documentPicker
  }
  
  func obtainDataFromImage(info: [UIImagePickerController.InfoKey: Any], completion: @escaping (URL) -> Void) {
    var mediaUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL
    if mediaUrl == nil {
      mediaUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL
    }
    completion(mediaUrl!)
  }
  
  func obtaiDataFromFile(urls: [URL], onSuccess: @escaping ([URL]) -> Void, onError: @escaping(String) -> Void) {
    var results: [URL] = []
    for url in urls {
      guard url.startAccessingSecurityScopedResource() else {
        onError("Can't access security scoped resource.")
        break
      }
      results.append(url)
      url.stopAccessingSecurityScopedResource()
    }
    
    onSuccess(results)
  }
  
  protocol FilePickerDelegate: UIImagePickerControllerDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate { }
}
