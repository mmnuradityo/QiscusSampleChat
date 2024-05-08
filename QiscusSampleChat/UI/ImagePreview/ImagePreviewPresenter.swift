//
//  ImagePreviewPresenter.swift
//  QiscusSampleChat
//
//  Created by Admin on 07/05/24.
//

import Foundation

protocol ImagePreviewPresenterProtocol {
  func loadThumbnailImage(imagUrl: URL?)
  func downloadImage(message: MessageModel)
}

class ImagePreviewPresenter: ImagePreviewPresenterProtocol {
  
  let repository: RepositoryProtocol
  let thumbnailManager: ThumbnailManagerProtocol
  let delegate: ImagePreviewDelegate
  
  init(
    repository: RepositoryProtocol,
    thumbnailManager: ThumbnailManagerProtocol,
    delegate: ImagePreviewDelegate
  ) {
    self.repository = repository
    self.thumbnailManager = thumbnailManager
    self.delegate = delegate
  }
  
  func loadThumbnailImage(imagUrl: URL?) {
    thumbnailManager.loadThumbnailImage(url: imagUrl) { imageData, imageState in
      if imageState == .success {
        self.delegate.onLoadImageSuccess(imageData: imageData)
      } else if imageState == .failed {
        self.delegate.onError(error: ChatError.custom(message: "Load image failed"))
      }
    }
  }
  
  func downloadImage(message: MessageModel) {
    repository.downloadFile(message: message) { messageResult in
      self.delegate.onDownloaded(message: messageResult)
    } onProgress: { progress in
      // do nothings
    } onError: { error in
      self.delegate.onError(error: ChatError.invalidDownloadFile)
    }

  }
  
  protocol ImagePreviewDelegate {
    func onLoadImageSuccess(imageData: Data?)
    func onDownloaded(message: MessageModel)
    func onError(error: ChatError)
  }
  
}
