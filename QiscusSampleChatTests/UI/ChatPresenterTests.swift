//
//  ChatPresenterTests.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 29/04/24.
//

import XCTest
@testable import QiscusSampleChat

class ChatPresenterTests: XCTestCase {
  
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
    let chatRoom = ChatRoomModel(
      id: "1", name: "name", avatarUrl: nil, participants: "member", lastMessage: nil
    )
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
    
    let message = MessageModel(
      id: "1",
      roomId: "1",
      time: "time",
      dateTime: "dateTime",
      status: .read,
      chatFrom: .me,
      data: MessageDataModel(dataType: .text, fileName: "fileName", url: "url", caption: ""),
      sender: MessageSenderModel(
        id: "1", name: "senderName", email: "email@mail.com", avatarImage: ImageModel(url: nil)
      )
    )
    var messages: [MessageModel] = []
    messages.append(message)
    let chatRoom = ChatRoomModel(
      id: "1", name: "name", avatarUrl: nil, participants: "member", lastMessage: nil
    )
    
    repository.chatRoom = chatRoom
    delegate.chatRoom = chatRoom
    
    sut.loadMoreMessages(roomId: "1", lastMessageId: "1")
    self.wait(for: [expectation], timeout: 1)
    
    XCTAssertEqual(repository.methodCalledCount, 1)
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
    
    var message = messageRequest.toComment().toMessage(withPayload: messageRequest.getPayload())
    delegate.message = message
    
    sut.sendMessageFile(messageRequest: messageRequest)
    
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(repository.methodCalledCount, 1)
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
  
  func onProgressUploadFIle(percent: Double) {
    XCTAssertEqual(percent, 1.0)
  }
  
  func onRoomEvent(chatRoomModel: ChatRoomModel) {
    // TODO:
  }
  
  func onMessageEvent(messageModel: MessageModel) {
    // TODO:
  }
  
  func onLogout() {
    if error != nil {
      XCTFail("Should not be called")
    } else {
      print("ChatPresenter: onLogout called")
    }
  }
  
}
