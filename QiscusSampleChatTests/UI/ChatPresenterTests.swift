//
//  ChatPresenterTests.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 29/04/24.
//

import XCTest
@testable import QiscusSampleChat

class ChatPresenterTests_loadData: XCTestCase {
  
  var delegate: ChatPresenterTestsDelegate!
  var repository: MockRepository!
  var sut: ChatPresenter!
  
  override func setUp() {
    super.setUp()
    delegate = ChatPresenterTestsDelegate()
    repository = MockRepository()
    
    sut = ChatPresenter(repository: repository, delegate: delegate)
  }
  
  override func tearDown() {
    super.tearDown()
    delegate = nil
    repository = nil
    sut = nil
  }
  
  func testChatPresenter_WhenLoadRoomWithMessage_ShouldBeError() {
    let expectation = self.expectation(description: "Expectation is error() method to be called")
    repository.expectation = expectation
    let error = ChatError.custom(message: "LoadRoomWithMessage error")
    delegate.error = error
    repository.error = error
    
    sut.loadRoomWithMessage(roomId: "1")
    
    self.wait(for: [expectation], timeout: 1)
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  func testChatPresenter_WhenLoadRoomWithMessage_ShouldBeSuccess() {
    let expectation = self.expectation(description: "Expectation is successFull() method to be called")
    repository.expectation = expectation
    
    var chatRoom = ChatRoomModel(
      id: "1", name: "name", avatarUrl: nil, participants: "member", lastMessage: nil
    )
    chatRoom.listMessages = [
      getMessage("1"), getMessage("2")
    ]
    
    repository.chatRoom = chatRoom
    delegate.chatRoom = chatRoom
    
    sut.loadRoomWithMessage(roomId: "1")
    self.wait(for: [expectation], timeout: 1)
    
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  func testChatPresenter_WhenLoadMoreMessages_ShouldBeError() {
    let expectation = self.expectation(description: "Expectation is error() method to be called")
    repository.expectation = expectation
    let error = ChatError.custom(message: "LoadMoreMessages error")
    delegate.error = error
    repository.error = error
    
    sut.loadMoreMessages(roomId: "1", lastMessageId: "1")
    self.wait(for: [expectation], timeout: 1)
    
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  func testChatPresenter_WhenLoadMoreMessages_ShouldBeSuccess() {
    let expectation = self.expectation(description: "Expectation is successFull() method to be called")
    repository.expectation = expectation
    
    var chatRoom = ChatRoomModel(
      id: "1", name: "name", avatarUrl: nil, participants: "member", lastMessage: nil
    )
    chatRoom.listMessages = [
      getMessage("1"), getMessage("2")
    ]
    
    repository.chatRoom = chatRoom
    delegate.chatRoom = chatRoom
    
    sut.loadMoreMessages(roomId: "1", lastMessageId: "1")
    self.wait(for: [expectation], timeout: 1)
    
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  private func getMessage(
    _ id: String, dataType: MessageType = .text
  ) -> MessageModel {
    var messageData = MessageDataModel(dataType: dataType, fileName: "", url: "", caption: "")
    
    return MessageModel(
      id: id, roomId: "", timeString: "", dateTime: "", timeStamp: Date(), status: .read, chatFrom: .me,
      data: messageData,
      sender: MessageSenderModel(
        id: "", name: "", email: "", avatarImage: ImageModel(url: nil)
      )
    )
  }
  
  func testChatPresenter_WhenLoadThumbnailImageURL_ShouldBeSuccess() {
    let expectation = self.expectation(description: "Expectation is successFull() method to be called")
    repository.expectation = expectation
    
    repository.imageData = Data()
    repository.imageState = .success
    
    sut.loadThumbnailImage(url: nil) { data, state in
      XCTAssertNotNil(data)
      XCTAssertEqual(state, .success)
    }
    
    self.wait(for: [expectation], timeout: 1)
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  func testChatPresenter_WhenLoadThumbnailImageMessage_ShouldBeSuccess() {
    let expectation = self.expectation(description: "Expectation is successFull() method to be called")
    repository.expectation = expectation
    
    repository.imageData = Data()
    repository.imageState = .success
    
    let message = getMessage("1")
    
    sut.loadThumbnailImage(message: message) { messageResult in
      XCTAssertNotNil(messageResult)
      XCTAssertEqual(messageResult.data.previewImage.state, .success)
    }
    
    self.wait(for: [expectation], timeout: 1)
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  func testChatPresenter_WhenLoadThumbnailVideoMessage_ShouldBeSuccess() {
    let expectation = self.expectation(description: "Expectation is successFull() method to be called")
    repository.expectation = expectation
    
    repository.imageData = Data()
    repository.imageState = .success
    
    let message = getMessage("1")
    
    sut.loadThumbnailVideo(message: message) { messageResult in
      XCTAssertNotNil(messageResult)
      XCTAssertEqual(messageResult.data.previewImage.state, .success)
    }
    
    self.wait(for: [expectation], timeout: 1)
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  func testChatPresenter_WhenDownloadFile_ShouldBeError() {
    let expectation = self.expectation(description: "Expectation is error() method to be called")
    repository.expectation = expectation
    
    let errorToResult = ChatError.custom(message: "Error when download file")
    repository.error = errorToResult
    
    let message = getMessage("1")
    
    sut.downloadFile(message: message) { messageResult in
      XCTFail("Success should be not called")
    } onProgress: { percent in
      XCTFail("Progress should be not called")
    } onError: { error in
      XCTAssertNotNil(error)
      XCTAssertEqual(error.localizedDescription, errorToResult.localizedDescription)
    }

    self.wait(for: [expectation], timeout: 1)
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  func testChatPresenter_WhenDownloadFile_ShouldBeSuccess() {
    let expectation = self.expectation(description: "Expectation is successFull() method to be called")
    repository.expectation = expectation
    
    repository.progresPercent = 1.0
    
    let message = getMessage("1")
    
    sut.downloadFile(message: message) { messageResult in
      XCTAssertNotNil(messageResult)
      XCTAssertEqual(messageResult.data.isDownloaded, true)
    } onProgress: { percent in
      XCTAssertEqual(percent, 1.0)
    } onError: { error in
      XCTFail("Error should be not called")
    }

    self.wait(for: [expectation], timeout: 1)
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
}

class ChatPresenterTests_SendMessage: XCTestCase {
  
  var delegate: ChatPresenterTestsDelegate!
  var repository: MockRepository!
  var sut: ChatPresenter!
  
  override func setUp() {
    super.setUp()
    delegate = ChatPresenterTestsDelegate()
    repository = MockRepository()
    
    sut = ChatPresenter(repository: repository, delegate: delegate)
  }
  
  override func tearDown() {
    super.tearDown()
    delegate = nil
    repository = nil
    sut = nil
  }
  
  func testChatPresenter_WhenSendMessage_ShouldBeError() {
    let expectation = self.expectation(description: "Expectation is error() method to be called")
    repository.expectation = expectation
    let error = ChatError.custom(message: "SendMessage error")
    delegate.error = error
    repository.error = error
    
    let messageRequest = MessageRequest(roomId: "1", message: "message", type: .text)
    var message = messageRequest.toComment().toMessage()
    message.status = .failed
    delegate.message = message
    
    sut.sendMessage(messageRequest: messageRequest)
    self.wait(for: [expectation], timeout: 1)
    
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  func testChatPresenter_WhenSendMessage_ShouldBeSuccess() {
    let expectation = self.expectation(description: "Expectation is successfull() method to be called")
    repository.expectation = expectation
    
    let messageRequest = MessageRequest(roomId: "1", message: "message", type: .text)
    var message = messageRequest.toComment().toMessage()
    repository.message = message
    
    message.status = .sent
    delegate.message = message
    
    sut.sendMessage(messageRequest: messageRequest)
    self.wait(for: [expectation], timeout: 1)
    
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  func testChatPresenter_WhenSendMessageFile_ShouldBeError() {
    let expectation = self.expectation(description: "Expectation is error() method to be called")
    repository.expectation = expectation
    let error = ChatError.custom(message: "SendMessageFile error")
    delegate.error = error
    repository.error = error
    
    let messageRequest = MessageRequest(roomId: "1", message: "message", type: .file)
    var message = messageRequest.toComment().toMessage()
    message.status = .failed
    delegate.message = message
    
    sut.sendMessageFile(messageRequest: messageRequest)
    self.wait(for: [expectation], timeout: 1)
    
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  func testChatPresenter_WhenSendMessageFile_ShouldBeSuccess() {
    let expectation = self.expectation(description: "Expectation is successfull() method to be called")
    repository.expectation = expectation
    
    let urlStringer = "https://dnlbo7fgjcc7f.cloudfront.net/sdksample/raw/upload/lgEaK4OS-m/DWSample1-TXT.txt"
    var messageRequest = MessageRequest(roomId: "1", message: "message", type: .file)
    messageRequest.with(
      fileRequest: MessageFileRequest(data: Data(), url: URL(string: urlStringer)!, caption: "caption")
    )
    var message = messageRequest.toComment().toMessage(withPayload: messageRequest.getPayload())
    repository.message = message
    
    message.status = .sent
    delegate.message = message
    
    sut.sendMessageFile(messageRequest: messageRequest)
    self.wait(for: [expectation], timeout: 1)
    
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  func testChatPresenter_WhenSendMessageFile_OnProgressBeCalled() {
    let expectation = self.expectation(description: "Expectation is successfull() method to be called")
    
    repository.expectation = expectation
    repository.progresPercent = 1.0
    
    
    let urlStringer = "https://dnlbo7fgjcc7f.cloudfront.net/sdksample/raw/upload/lgEaK4OS-m/DWSample1-TXT.txt"
    var messageRequest = MessageRequest(roomId: "1", message: "message", type: .file)
    messageRequest.fileRequest = MessageFileRequest(
      data: Data(), url: URL(string: urlStringer)!, name: "fileName", caption: "caption"
    )
    
    let message = messageRequest.toComment().toMessage(withPayload: messageRequest.getPayload())
    delegate.message = message
    
    sut.sendMessageFile(messageRequest: messageRequest)
    
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
}

class ChatPresenterTests_Event: XCTestCase {
  
  var delegate: ChatPresenterTestsDelegate!
  var repository: MockRepository!
  var sut: ChatPresenter!
  
  override func setUp() {
    super.setUp()
    delegate = ChatPresenterTestsDelegate()
    repository = MockRepository()
    
    sut = ChatPresenter(repository: repository, delegate: delegate)
  }
  
  override func tearDown() {
    super.tearDown()
    delegate = nil
    repository = nil
    sut = nil
  }
  
  func testChatPresenter_CallMarkAsRead() {
    sut.markAsRead(roomId: "", messageId: "")
  }
  
  func testChatPresenter_CallEventRoom() {
    let chatRoom = ChatRoomModel(
      id: "1", name: "", avatarUrl: nil, participants: "", lastMessage: nil
    )
    sut.onEventRoom(room: chatRoom)
  }
  
  func testChatPresenter_CallEventMessage() {
    var messageData = MessageDataModel(dataType: .text, fileName: "", url: "", caption: "caption")
    let message =  MessageModel(
      id: "1", roomId: "", timeString: "", dateTime: "", timeStamp: Date(), status: .read, chatFrom: .me,
      data: messageData,
      sender: MessageSenderModel(
        id: "", name: "", email: "", avatarImage: ImageModel(url: nil)
      )
    )
    sut.onEventMessage(message: message)
  }
  
  func testChatPresenter_WhenLogout_OnLogoutNotBeCalled() {
    let expectation = self.expectation(description: "Expectation is error() method to be called")
    repository.expectation = expectation
    let error = ChatError.custom(message: "Logout error")
    repository.error = error
    delegate.error = error
    
    sut.logout()
    
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
  func testChatPresenter_WhenLogout_OnLogoutBeCalled() {
    let expectation = self.expectation(description: "Expectation is successfull() method to be called")
    repository.expectation = expectation
    
    sut.logout()
    
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(repository.methodCalledCount, 1)
  }
  
}

// MARK: ~ View Delegate
class ChatPresenterTestsDelegate: ChatPresenter.ChatDelete {
  
  var chatRoom: ChatRoomModel?
  var message: MessageModel?
  var error: ChatError?
  var methodeCallerCaount = 0
  
  func error(error: ChatError) {
    self.error = error
  }
  
  func onLoadMore(loadMoreId: String) {
    print("ChatPresenter: onLoadMore called with value = \(loadMoreId)")
  }
  
  func onLoading(isLoading: Bool) {
    print("ChatPresenter: onLoading called with value = \(isLoading)")
  }
  
  func onRoomWithMessage(chatRoomModel: ChatRoomModel) {
    XCTAssertNil(error)
    XCTAssertEqual(chatRoomModel.id, self.chatRoom?.id)
    print("ChatPresenter: onRoomWithMessage called with id = \(chatRoomModel.id)")
  }
  
  func onMessages(messageModels: [MessageModel]) {
    print("ChatPresenter: onMessage called with count = \(messageModels.count)")
  }
  
  func onSendMessage(messageModel: MessageModel) {
    methodeCallerCaount += 1
    XCTAssertNotNil(message)
    XCTAssertEqual(messageModel.status, methodeCallerCaount == 1 ?  .sending : message!.status)
    print("ChatPresenter: onMessage called with status = \(messageModel.status)")
  }
  
  func onError(error: ChatError) {
    XCTAssertNil(chatRoom)
    XCTAssertEqual(error, self.error)
    print("ChatPresenter: onError called with value \(error.localizedDescription)")
  }
  
  func onProgressUploadFile(messageId: String, percent: Double) {
    XCTAssertEqual(percent, 1.0)
  }
  
  func onRoomEvent(chatRoomModel: ChatRoomModel) {
    XCTAssertNotNil(chatRoomModel)
  }
  
  func onMessageEvent(messageModel: MessageModel) {
    XCTAssertNotNil(messageModel)
  }
  
  func onLogout() {
    if error != nil {
      XCTFail("Should not be called")
    } else {
      print("ChatPresenter: onLogout called")
    }
  }
  
}
