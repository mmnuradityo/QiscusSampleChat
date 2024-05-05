//
//  RepositoryTests.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 23/04/24.
//

import XCTest
@testable import QiscusSampleChat
@testable import QiscusCore
@testable import SwiftyJSON

class RepositoryTests_UserLoginAndLogout: XCTestCase {
  
  var imageManager: MockImageManager!
  var userRequest: UserRequest!
  var qiscusManager: MockQiscusManager!
  var dataStore: DataStoreProtocol!
  var userLocalDateBase: MockUserLocalDateBase!
  
  var sut: RepositoryProtocol!
  
  override func setUp() {
    super.setUp()
    userRequest = UserRequest(
      userId: "1",
      userKey: "userKey",
      username: "userName",
      avatarURL: nil,
      extras: nil
    )
    
    imageManager = MockImageManager()
    qiscusManager =  MockQiscusManager()
    userLocalDateBase = MockUserLocalDateBase()
    dataStore = DataStore(userLocalDateBase: userLocalDateBase)
    
    sut = Repository(dataStore: dataStore, imageManager: imageManager, qiscusManager: qiscusManager)
  }
  
  override func tearDown() {
    super.tearDown()
    userRequest = nil
    qiscusManager = nil
    sut = nil
    dataStore = nil
    userLocalDateBase = nil
    imageManager = nil
  }
  
  func testRepository_WhenInvalidLoginUserRequestProvided_OnErrorMustBeCalled() {
    qiscusManager.error = QError.init(message: "invalid login")
    
    sut.login(userRequest: userRequest) { userModel in
      XCTFail("Should not be called")
    } onError: { error in
      XCTAssertNil(self.sut.getUserActive())
      XCTAssertNotNil(self.qiscusManager.error)
      XCTAssertEqual(
        self.qiscusManager.error!.message, error.localizedDescription,
        "Error message should be equal with message \(error.localizedDescription)"
      )
    }
  }
  
  func testRepository_WhenSaveUserIsFailed_OnErrorMustBeCalled() {
    userLocalDateBase.isSaved = false
    
    sut.login(userRequest: userRequest) { userModel in
      XCTFail("Should not be called")
    } onError: { error in
      XCTAssertNil(self.sut.getUserActive())
      XCTAssertEqual(
        error, UserError.invalidSaveUser,
        "Error message should be equal with message \(error.localizedDescription)"
      )
    }
  }
  
  func testRepository_WhenValidLoginUserRequestProvided_OnSuccessMustBeCalled() {
    sut.login(userRequest: userRequest) { userModel in
      XCTAssertNotNil(userModel)
      XCTAssertNotNil(self.sut.getUserActive())
    } onError: { error in
      XCTFail("Should not be called")
    }
  }
  
  func testRepository_WhenLogoutFailed_CompletionNotBeCalled() {
    let userActive = UserActive(id: "1", email: "email@mail.com")
    _ = userLocalDateBase.saveUser(user: userActive)
    qiscusManager.error = QError.init(message: "invalid logout")
    
    sut.logout {
      self.userLocalDateBase.isClear = false
      XCTFail("Should not be called")
    }
    XCTAssertNotNil(self.sut.getUserActive())
  }
  
  func testRepository_WhenLogoutButUserActiveIsNil_CompletionNotBeCalled() {
    qiscusManager.error = QError.init(message: "invalid logout")
    
    sut.logout {
      self.userLocalDateBase.isClear = false
      XCTFail("Should not be called")
    }
    XCTAssertNil(self.sut.getUserActive())
  }
  
  func testRepository_WhenLogoutSuccess_CompletionBeCalled() {
    let userActive = UserActive(id: "1", email: "email@mail.com")
    _ = userLocalDateBase.saveUser(user: userActive)
    sut.logout {
      XCTAssertNil(self.sut.getUserActive())
    }
  }
  
}

class RepositoryTests_LoadChatRooms: XCTestCase {
  
  var imageManager: MockImageManager!
  var qiscusManager: MockQiscusManager!
  var dataStore: DataStoreProtocol!
  var userLocalDateBase: MockUserLocalDateBase!
  
  var sut: RepositoryProtocol!
  
  override func setUp() {
    super.setUp()
    imageManager = MockImageManager()
    qiscusManager =  MockQiscusManager()
    userLocalDateBase = MockUserLocalDateBase()
    dataStore = DataStore(userLocalDateBase: userLocalDateBase)
    
    sut = Repository(
      dataStore: dataStore,
      imageManager: imageManager,
      qiscusManager: qiscusManager,
      dispatchQueue: .main
    )
  }
  
  override func tearDown() {
    super.tearDown()
    qiscusManager = nil
    sut = nil
    dataStore = nil
    userLocalDateBase = nil
    imageManager = nil
  }
  
  func testRepository_WhenLoadRoomsList_OnErrorBeCalled() {
    let expectation = self.expectation(description: "Expectation is error() method to be called")
    let error = QError.init(message: "loadRooms error")
    
    qiscusManager.expectation = expectation
    qiscusManager.error = error
    
    sut.loadRooms(page: 1, limit: 1) { rooms in
      XCTFail("Should not be called")
    } onError: { chatError in
      XCTAssertNotNil(chatError)
      XCTAssertEqual(chatError, ChatError.custom(message: error.message))
    }
    
    self.wait(for: [expectation], timeout: 1)
    XCTAssertEqual(qiscusManager.methodCalledCount, 1)
  }
  
  func testRepository_WhenLoadRoomsList_OnSuccessBeCalled() {
    let expectation = self.expectation(description: "Expectation is succesfull() method to be called")
    
    let meta = Meta(json: JSON.init(
      parseJSON: "{ \"current_page\": 1, \"total_page\": 2 }"
    ))
    let result: ([RoomModel], Meta) = ([], meta)
    
    qiscusManager.expectation = expectation
    qiscusManager.roomWithMeta = result
    
    sut.loadRooms(page: 1, limit: 1) { rooms in
      XCTAssertNotNil(rooms)
      XCTAssertEqual(rooms.currentPage, result.1.currentPage)
      XCTAssertEqual(rooms.listRooms.count, result.0.count)
    } onError: { chatError in
      XCTFail("Should not be called")
    }
    
    self.wait(for: [expectation], timeout: 1)
    XCTAssertEqual(qiscusManager.methodCalledCount, 1)
  }
}

class RepositoryTests_LoadRoomMessages: XCTestCase {
  
  var imageManager: MockImageManager!
  var qiscusManager: MockQiscusManager!
  var dataStore: DataStoreProtocol!
  var userLocalDateBase: MockUserLocalDateBase!
  
  var sut: RepositoryProtocol!
  
  override func setUp() {
    super.setUp()
    imageManager = MockImageManager()
    qiscusManager =  MockQiscusManager()
    userLocalDateBase = MockUserLocalDateBase()
    dataStore = DataStore(userLocalDateBase: userLocalDateBase)
    
    sut = Repository(
      dataStore: dataStore,
      imageManager: imageManager,
      qiscusManager: qiscusManager,
      dispatchQueue: .main
    )
  }
  
  override func tearDown() {
    super.tearDown()
    qiscusManager = nil
    sut = nil
    dataStore = nil
    userLocalDateBase = nil
    imageManager = nil
  }
  
  func testRepository_WhenLoadRoomWithMessgae_OnErrorBeCalled() {
    let expectation = self.expectation(description: "Expectation is error() method to be called")
    let error = QError.init(message: "LoadRoomWithMessage error")
    
    qiscusManager.expectation = expectation
    qiscusManager.error = error
    
    sut.loadRoomWithMessgae(roomId: "1") { chatRoom in
      XCTFail("Should not be called")
    } onError: { chatError in
      XCTAssertNotNil(chatError)
      XCTAssertEqual(chatError, ChatError.custom(message: error.message))
    }
    
    self.wait(for: [expectation], timeout: 1)
    XCTAssertEqual(qiscusManager.methodCalledCount, 1)
  }
  
  func testRepository_WhenLoadRoomWithMessgae_OnSuccessBeCalled() {
    let expectation = self.expectation(description: "Expectation is succesfull() method to be called")
    
    let room = RoomModel()
    room.id = "202"
    
    let comment = CommentModel()
    comment.id = "101"
    
    var comments: [CommentModel] = []
    comments.append(comment)
    
    qiscusManager.expectation = expectation
    qiscusManager.room = room
    qiscusManager.comments = comments
    
    sut.loadRoomWithMessgae(roomId: "1") { chatRoom in
      XCTAssertNotNil(chatRoom)
      XCTAssertEqual(chatRoom.id, room.id)
      XCTAssertEqual(chatRoom.listMessages[0].id, comments[0].id)
    } onError: { chatError in
      XCTFail("Should not be called")
    }
    
    self.wait(for: [expectation], timeout: 1)
    XCTAssertEqual(qiscusManager.methodCalledCount, 1)
  }
  
  func testRepository_WhenLoadMoreMessgae_OnErrorBeCalled() {
    let expectation = self.expectation(description: "Expectation is error() method to be called")
    let error = QError.init(message: "LoadMoreMessgae error")
    
    qiscusManager.expectation = expectation
    qiscusManager.error = error
    
    sut.loadMoreMessages(roomId: "1", lastMessageId: "1", limit: 1) { messages in
      XCTFail("Should not be called")
    } onError: { chatError in
      XCTAssertNotNil(chatError)
      XCTAssertEqual(chatError, ChatError.custom(message: error.message))
    }
    
    self.wait(for: [expectation], timeout: 1)
    XCTAssertEqual(qiscusManager.methodCalledCount, 1)
  }
  
  func testRepository_WhenLoadMoreMessgae_OnSuccessBeCalled() {
    let expectation = self.expectation(description: "Expectation is succesfull() method to be called")
    let comment = CommentModel()
    comment.id = "101"
    
    var comments: [CommentModel] = []
    comments.append(comment)
    
    qiscusManager.expectation = expectation
    qiscusManager.comments = comments
    
    sut.loadMoreMessages(roomId: "1", lastMessageId: "1", limit: 1) { messages in
      XCTAssertNotNil(messages)
      XCTAssertEqual(messages[0].id, comments[0].id)
    } onError: { chatError in
      XCTFail("Should not be called")
    }
    
    self.wait(for: [expectation], timeout: 1)
    XCTAssertEqual(qiscusManager.methodCalledCount, 1)
  }
  
  func testRepository_WhenLoadThumbnailImage_OnDataShouldBeFailed() {
    sut.loadThumbnailImage(url: nil) { data, state in
      XCTAssertNil(data)
      XCTAssertEqual(state, .failed)
    }
  }
  
  func testRepository_WhenLoadThumbnailImage_OnDataShouldBeSuccess() {
    imageManager.data = Data()
    
    sut.loadThumbnailImage(url: nil) { data, state in
      XCTAssertNotNil(data)
      XCTAssertEqual(state, .success)
    }
  }
  
  func testRepository_WhenLoadThumbnailVideo_OnDataShouldBeFailed() {
    sut.loadThumbnailVideo(url: nil) { data, state in
      XCTAssertNil(data)
      XCTAssertEqual(state, .failed)
    }
  }
  
  func testRepository_WhenLoadThumbnailVideo_OnDataShouldBeSuccess() {
    imageManager.data = Data()
    
    sut.loadThumbnailVideo(url: nil) { data, state in
      XCTAssertNotNil(data)
      XCTAssertEqual(state, .success)
    }
  }
  
}


class RepositoryTests_SendMessage: XCTestCase {
  
  var imageManager: MockImageManager!
  var userRequest: UserRequest!
  var qiscusManager: MockQiscusManager!
  var dataStore: DataStoreProtocol!
  var userLocalDateBase: MockUserLocalDateBase!
  
  var sut: RepositoryProtocol!
  
  override func setUp() {
    super.setUp()
    imageManager = MockImageManager()
    qiscusManager =  MockQiscusManager()
    userLocalDateBase = MockUserLocalDateBase()
    dataStore = DataStore(userLocalDateBase: userLocalDateBase)
    
    sut = Repository(
      dataStore: dataStore,
      imageManager: imageManager,
      qiscusManager: qiscusManager,
      dispatchQueue: .main
    )
  }
  
  override func tearDown() {
    super.tearDown()
    qiscusManager = nil
    sut = nil
    dataStore = nil
    userLocalDateBase = nil
    imageManager = nil
  }
  
  func testRepository_WhenSendMessage_OnErrorBeCalled() {
    let expectation = self.expectation(description: "Expectation is error() method to be called")
    let error = QError.init(message: "Send Message failed")
    
    qiscusManager.error = error
    qiscusManager.expectation = expectation
    
    let request = MessageRequest(roomId: "1", message: "message", type: .text)
    
    sut.sendMessage(messageRequest: request) { message in
      XCTFail("Should not be called")
    } onError: { chatError in
      XCTAssertNotNil(chatError)
      XCTAssertEqual(chatError, ChatError.custom(message: error.message))
    }
    
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(qiscusManager.methodCalledCount, 1)
  }
  
  func testRepository_WhenSendMessage_OnSuccessBeCalled() {
    let expectation = self.expectation(description: "Expectation is successfull() method to be called")
    let comment = CommentModel()
    comment.id = "102"
    comment.roomId = "1002"
    
    qiscusManager.comment = comment
    qiscusManager.expectation = expectation
    
    let request = MessageRequest(roomId: "1", message: "message", type: .text)
    
    sut.sendMessage(messageRequest: request) { message in
      XCTAssertNotNil(message)
      XCTAssertEqual(message.roomId, comment.roomId)
    } onError: { chatError in
      XCTFail("Should not be called")
    }
    
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(qiscusManager.methodCalledCount, 1)
  }
  
  func testRepository_WhenUploadFileSendMessage_OnErrorBeCalledWithEmptyUploadFile() {
    let error = QError.init(message: ChatError.invalidEmptyUploadFile.localizedDescription)
    qiscusManager.error = error
    
    let request = MessageRequest(roomId: "1", message: "message", type: .file)
    
    sut.sendMessageFile(messageRequest: request) { message in
      XCTFail("Success should not be called")
    } onError: { chatError in
      XCTAssertNotNil(chatError)
      XCTAssertEqual(chatError, ChatError.invalidEmptyUploadFile)
    } progress: { percent in
      XCTFail("Progress should not be called")
    }
    
    XCTAssertEqual(qiscusManager.methodCalledCount, 0)
  }
  
  func testRepository_WhenUploadFileSendMessage_OnErrorBeCalled() {
    let expectation = self.expectation(description: "Expectation is error() method to be called")
    let error = QError.init(message: ChatError.invalidEmptyUploadFile.localizedDescription)
    
    qiscusManager.error = error
    qiscusManager.expectation = expectation
    
    var request = MessageRequest(roomId: "1", message: "message", type: .file)
    request.fileRequest = MessageFileRequest(data: Data(), url: nil, name: "fileName", caption: "caption")
    
    sut.sendMessageFile(messageRequest: request) { message in
      XCTFail("Susscess should not be called")
    } onError: { chatError in
      XCTAssertNotNil(chatError)
      XCTAssertEqual(chatError, ChatError.custom(message: error.message))
    } progress: { percent in
      XCTFail("Progress should not be called")
    }
    
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(qiscusManager.methodCalledCount, 1)
  }
  
  func testRepository_WhenUploadFileSendMessage_OnSuccessBeCalled() {
    let expectation = self.expectation(description: "Expectation is success() method to be called")
    
    var request = MessageRequest(roomId: "1", message: "message", type: .file)
    request.fileRequest = MessageFileRequest(data: Data(), url: nil, name: "fileName", caption: "caption")
    let comment = request.toComment()
    
    let urlStringer = "https://dnlbo7fgjcc7f.cloudfront.net/sdksample/raw/upload/lgEaK4OS-m/DWSample1-TXT.txt"
    let file = request.toFileUpload()
    var fileModel = FileModel(url: URL(string: urlStringer)!)
    fileModel.name = file?.name ?? ""
    comment.payload = [
      MessageDataParams.url.rawValue: urlStringer,
      MessageDataParams.fileName.rawValue: file?.name ?? "",
      MessageDataParams.caption.rawValue: file?.caption ?? ""
    ]
    
    qiscusManager.expectation = expectation
    qiscusManager.comment = comment
    qiscusManager.fileModel = fileModel
    
    sut.sendMessageFile(messageRequest: request) { message in
      XCTAssertNotNil(message)
      XCTAssertEqual(message.data.dataType, .file)
    } onError: { chatError in
      XCTFail("Error should not be called, with error \(chatError.localizedDescription)")
    } progress: { percent in
      XCTFail("Progress should not be called")
    }
    
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(qiscusManager.methodCalledCount, 1)
  }
  
  func testRepository_WhenUploadFileSendMessage_OnProgressBeCalled() {
    let expectation = self.expectation(description: "Expectation is success() method to be called")
    
    qiscusManager.expectation = expectation
    qiscusManager.progresPercent = 1.0
    
    var request = MessageRequest(roomId: "1", message: "message", type: .file)
    request.fileRequest = MessageFileRequest(data: Data(), url: nil, name: "fileName", caption: "caption")
    
    sut.sendMessageFile(messageRequest: request) { message in
      XCTFail("Success should not be called")
    } onError: { chatError in
      XCTFail("Error should not be called")
    } progress: { percent in
      XCTAssertEqual(percent, 1.0)
    }
    
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(qiscusManager.methodCalledCount, 1)
  }
  
}
