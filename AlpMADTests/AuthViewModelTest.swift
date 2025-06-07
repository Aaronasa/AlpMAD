//
//  AuthViewModelTest.swift
//  AlpMADTests
//
//  Created by Aaron Asa Soelistiono on 04/06/25.
//

import XCTest
@testable import AlpMAD
import FirebaseDatabase
import Firebase

class AuthMockDataSnapshot: DataSnapshot {
    private let _value: Any?
    override var value: Any? { _value }
    init(value: Any?) { self._value = value; super.init() }
}

class AuthMockDatabaseReference: NSObject {
    var mockData: [String: Any] = [:]
    var lastChildPath: String = ""
    var observeCallback: ((DataSnapshot) -> Void)?

    func child(_ pathString: String) -> AuthMockDatabaseReference {
        lastChildPath = pathString
        return self
    }

    func observeSingleEvent(of event: DataEventType, with block: @escaping (DataSnapshot) -> Void) {
        observeCallback = block
    }

    func simulateFetch(with data: [String: Any]) {
        let snapshot = AuthMockDataSnapshot(value: data)
        observeCallback?(snapshot)
    }
}

@MainActor
class TestableAuthViewModel: AuthViewModel {
    var mockRef: AuthMockDatabaseReference?

    override init() {
        super.init()
    }

    func injectMock(ref: AuthMockDatabaseReference) {
        self.mockRef = ref
    }

    override func fetchUserData(uid: String) {
        mockRef?.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else { return }

            let user = MyUser(
                uuid: uid,
                email: value["email"] as? String ?? "",
                password: value["password"] as? String ?? "",
                age: value["age"] as? Int ?? 0
            )

            Task { @MainActor in
                self.myUser = user
            }
        }
    }
}


final class AuthViewModelTests: XCTestCase {
    @MainActor
    func testFetchUserDataLoadsCorrectly() async {
        let mockRef = AuthMockDatabaseReference()
        let mockData: [String: Any] = [
            "email": "test@example.com",
            "password": "123456",
            "age": 21
        ]

        let viewModel = await TestableAuthViewModel()
        await viewModel.injectMock(ref: mockRef)

        await viewModel.fetchUserData(uid: "mock-uid")
        mockRef.simulateFetch(with: mockData)

        try? await Task.sleep(nanoseconds: 300_000_000)

        XCTAssertEqual(viewModel.myUser.email, "test@example.com")
        XCTAssertEqual(viewModel.myUser.password, "123456")
        XCTAssertEqual(viewModel.myUser.age, 21)
    }
    @MainActor
    func testSignInFailure() async {
        let viewModel = TestableAuthViewModel()
        viewModel.myUser.email = "wrong@example.com"
        viewModel.myUser.password = "wrongpassword"

        await viewModel.signIn()

        XCTAssertTrue(viewModel.falseCredential)
    }
}
