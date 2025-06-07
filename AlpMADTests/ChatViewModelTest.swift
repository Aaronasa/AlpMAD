//
//  ChatViewModelTest.swift
//  AlpMADTests
//
//  Created by Aaron Asa Soelistiono on 04/06/25.
//

import XCTest

class MockDatabaseReference: DatabaseReferencing {
    var setValueCalled = false
    var savedData: Any?
    var children: [String: MockDatabaseReference] = [:]

    func child(_ pathString: String) -> DatabaseReferencing {
        let childRef = MockDatabaseReference()
        children[pathString] = childRef
        return childRef
    }

    func setValue(_ value: Any?) {
        setValueCalled = true
        savedData = value
    }
}

final class ChatViewModelTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSendMessage_savesCorrectDataToMockDatabase() throws {
            let mockRef = MockDatabaseReference()
            let testUserId = "user1"
            let viewModel = ChatViewModel(overrideUserId: testUserId, ref: mockRef)

            let receiverId = "user2"
            let messageText = "Hello, unit testing!"
            viewModel.sendMessage(to: receiverId, messageText: messageText)

            let chatId = "user1_user2"

            guard let chatNode = mockRef.children[chatId] else {
                XCTFail("Expected chatId node in mock database")
                return
            }

            XCTAssertEqual(chatNode.children.count, 1, "Expected one message child node")

            guard let messageNode = chatNode.children.values.first else {
                XCTFail("Expected a message node")
                return
            }

            XCTAssertTrue(messageNode.setValueCalled, "Expected setValue to be called on message node")
            XCTAssertNotNil(messageNode.savedData, "Expected savedData to be non-nil")

            if let savedDict = messageNode.savedData as? [String: Any],
               let savedMessage = savedDict["message"] as? String {
                XCTAssertEqual(savedMessage, messageText, "Message text should be saved correctly")
            } else {
                XCTFail("Saved data is not in expected format")
            }
        }

}
