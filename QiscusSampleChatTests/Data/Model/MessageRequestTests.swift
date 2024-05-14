//
//  MessageRequestTests.swift
//  QiscusSampleChatTests
//
//  Created by Admin on 01/05/24.
//
import XCTest
@testable import QiscusSampleChat

class MessageRequestTests: XCTestCase {
  
  static var documentsURL: URL!
  static var textFileURL: URL!
  
  override class func setUp() {
    super.setUp()
    documentsURL = try! FileManager.default.url(
      for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false
    )
    textFileURL = documentsURL.appendingPathComponent("sample.txt")
    createDummyTextFile()
  }
  
  override class func tearDown() {
    super.tearDown()
    removeDummyTextFile()
    documentsURL = nil
    textFileURL = nil
  }
  
  static func createDummyTextFile() {
    let textContent = "This is a sample.txt dummy text file."
    do {
      try textContent.write(to: textFileURL, atomically: true, encoding: .utf8)
    } catch {
      XCTFail("Failed to create dummy text file: \(error)")
    }
  }
  
  static func removeDummyTextFile() {
    if FileManager.default.fileExists(atPath: textFileURL.absoluteString) {
      do {
        try FileManager.default.removeItem(at: textFileURL)
      } catch {
        XCTFail("Failed to remove dummy text file: \(error)")
      }
    }
  }
  
  func testMessageRequest_WhenToCommentGetPayLoad_ShouldBeValid() {
    do {
      let dataFile = try Data(contentsOf: MessageRequestTests.textFileURL)
      
      var messageRequest: MessageRequest = MessageRequest(roomId: "1", message: "message", type: .file)
      messageRequest.with(fileRequest:  MessageFileRequest(
        data: dataFile, 
        url: MessageRequestTests.textFileURL,
        name: "fileName",
        caption: "caption"
      ))
      let comment = messageRequest.toComment()
      comment.payload = messageRequest.getPayload()
      let sut = comment.payload![MessageDataParams.url.rawValue] as! String
      
      XCTAssertNotNil(comment.payload)
      XCTAssertEqual(sut, MessageRequestTests.textFileURL.absoluteString)
    } catch {
      XCTFail("error when try to transform urlString to URL with error = \(error.localizedDescription)")
    }
  }
  
}
