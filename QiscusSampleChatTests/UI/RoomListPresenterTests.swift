//
//  RoomListPresenterTests.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 15/05/24.
//

import XCTest
@testable import QiscusSampleChat

class RoomListPresenterTests: XCTestCase {
  
  var repository: MockRepository!
  var delegate: RoomListPresenterTestDelegate!
  var sut: RoomListPresenter!
  
  override func setUp() {
    super.setUp()
    repository = MockRepository()
    delegate = RoomListPresenterTestDelegate()
    
    sut = RoomListPresenter(
      repository: repository, delegate: delegate
    )
  }
  
  override func tearDown() {
    super.tearDown()
    delegate = nil
    repository = nil
    sut = nil
  }
  
  func testRoomListPresenter_WhenLoadRooms_ShouldBeError() {
    let expectation = self.expectation(description: "Expectation is error() method to be called")
    repository.expectation = expectation
    
    let error = ChatError.custom(message: "Failed to load chatrooms list")
    repository.error = error
    delegate.error = error
    
    sut.loadRooms(page: 1)
    
    self.wait(for: [expectation], timeout: 1)
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  func testRoomListPresenter_WhenLoadRooms_ShouldBeSuccess() {
    let expectation = self.expectation(description: "Expectation is successfull() method to be called")
    repository.expectation = expectation
    
    let rooms: [ChatRoomModel] = []
    let chatRoomList = ChatRoomListModel(currentPage: 1024, rooms: rooms)
    
    repository.chatRoomList = chatRoomList
    delegate.chatRoomList = chatRoomList
    
    sut.loadRooms(page: 1)
    
    self.wait(for: [expectation], timeout: 1)
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  func testRoomListPresenter_CallLoadThumbnailImage() {
    repository.imageData = Data()
    repository.imageState = .success
    
    sut.loadThumbnailImage(url: nil) { data, sate in
      XCTAssertNotNil(data)
      XCTAssertEqual(sate, .success)
    }
  }
  
  func testRoomListPresenter_CallEventRoom() {
    let chatRoom = ChatRoomModel(
      id: "1", name: "", avatarUrl: nil, participants: "", lastMessage: nil
    )
    sut.onEventRoom(room: chatRoom)
  }
  
  func testRoomListPresenter_CallEventMessage() {
    let messageData = MessageDataModel(dataType: .text, fileName: "", url: "", caption: "caption")
    let message =  MessageModel(
      id: "1", roomId: "", timeString: "", dateTime: "", timeStamp: Date(), status: .read, chatFrom: .me,
      data: messageData,
      sender: MessageSenderModel(
        id: "", name: "", email: "", avatarImage: ImageModel(url: nil)
      )
    )
    sut.onEventMessage(message: message)
  }
  
}

class RoomListPresenterTestDelegate: RoomListPresenter.RoomListDelegate {
  
  var chatRoomList: ChatRoomListModel?
  var error: ChatError?
  var loadingCounter = 1
  
  func onloading(isLoading: Bool) {
    if (error != nil && loadingCounter == 2) || loadingCounter == 2 {
      XCTAssertFalse(isLoading)
    } else if loadingCounter == 1 {
      XCTAssertTrue(isLoading)
    }
    loadingCounter += 1
  }
  
  func onRooms(chatRoomList: ChatRoomListModel) {
    XCTAssertNotNil(chatRoomList)
    XCTAssertNotNil(self.chatRoomList)
    XCTAssertEqual(chatRoomList.currentPage, self.chatRoomList!.currentPage)
  }
  
  func onRoom(room: ChatRoomModel) {
    XCTAssertNotNil(room)
  }
  
  func onMessage(message: MessageModel) {
    XCTAssertNotNil(message)
  }
  
  func onError(error: ChatError) {
    XCTAssertNotNil(error)
    XCTAssertNotNil(self.error)
    XCTAssertEqual(error.localizedDescription, self.error!.localizedDescription)
  }
  
}
