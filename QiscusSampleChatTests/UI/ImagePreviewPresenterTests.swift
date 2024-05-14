//
//  ImagePreviewPresenterTests.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 15/05/24.
//


import XCTest
import AVFoundation
@testable import QiscusSampleChat

class ImagePreviewPresenterTests: XCTestCase {
  
  var delegate : ImagePreviewPresenterTestsDelegate!
  var thumbnailManager: MockThumbnailManager!
  var repository: MockRepository!
  var sut: ImagePreviewPresenter!
  
  override func setUp() {
    super.setUp()
    thumbnailManager = MockThumbnailManager()
    delegate = ImagePreviewPresenterTestsDelegate()
    repository = MockRepository()
    
    sut = ImagePreviewPresenter(
      repository: repository,
      thumbnailManager: thumbnailManager,
      delegate: delegate
    )
  }
  
  override func tearDown() {
    super.tearDown()
    thumbnailManager = nil
    repository = nil
    delegate = nil
    sut = nil
  }
  
  func testImagePreviewPresenter_WhenLoadThumbnailImage_ShouldBeError() {
    thumbnailManager.imageState = .failed
    delegate.error = ChatError.custom(message: "Load image failed")
    
    sut.loadThumbnailImage(imagUrl: nil)
  }
  
  func testImagePreviewPresenter_WhenLoadThumbnailImage_ShouldBeSuccess() {
    thumbnailManager.imagedata = Data()
    thumbnailManager.imageState = .success
    
    sut.loadThumbnailImage(imagUrl: nil)
  }
  
  func testImagePreviewPresenter_WhenDownloadImage_ShouldBeError() {
    let expectation = self.expectation(description: "Expectation is error() method to be called")
    repository.expectation = expectation
    
    let error = ChatError.invalidDownloadFile
    repository.error = error
    delegate.error = error
    
    var message = getMessage("1")
    sut.downloadImage(message: message)
    
    self.wait(for: [expectation], timeout: 1)
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  func testImagePreviewPresenter_WhenDownloadImage_ShouldBeSuccess() {
    let expectation = self.expectation(description: "Expectation is sucessfull() method to be called")
    repository.expectation = expectation
    
    repository.progresPercent = 1.0
    
    var message = getMessage("1")
    sut.downloadImage(message: message)
    
    self.wait(for: [expectation], timeout: 1)
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  private func getMessage(
    _ id: String
  ) -> MessageModel {
    var messageData = MessageDataModel(dataType: .image, fileName: "", url: "", caption: "")
    
    return MessageModel(
      id: id, roomId: "", timeString: "", dateTime: "", timeStamp: Date(), status: .read, chatFrom: .me,
      data: messageData,
      sender: MessageSenderModel(
        id: "", name: "", email: "", avatarImage: ImageModel(url: nil)
      )
    )
  }
}

class ImagePreviewPresenterTestsDelegate: ImagePreviewPresenter.ImagePreviewDelegate {
  
  var error: ChatError?
  
  func onLoadImageSuccess(imageData: Data?) {
    XCTAssertNotNil(imageData)
  }
  
  func onDownloaded(message: MessageModel) {
    XCTAssertNotNil(message)
    XCTAssertEqual(message.data.isDownloaded, true)
  }
  
  func onError(error: ChatError) {
    XCTAssertNotNil(error)
    XCTAssertNotNil(self.error)
    XCTAssertEqual(error.localizedDescription, self.error!.localizedDescription)
  }
  
}
