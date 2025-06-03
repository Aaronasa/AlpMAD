//
//  AuthViewModel.swift
//  AlpMAD
//
//  Created by Aaron Asa Soelistiono on 18/05/25.
//

import FirebaseAuth
import FirebaseDatabase
import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isSignedIn: Bool
    @Published var myUser: MyUser
    @Published var falseCredential: Bool
    @Published var userId: String?
    @Published var isLoggedIn = false
    @Published var showLogin = true

    private let dbRef = Database.database().reference()

    init() {
        self.user = nil
        self.isSignedIn = false
        self.falseCredential = false
        self.myUser = MyUser()
        self.checkUserSession()
    }

    func checkUserSession() {
        self.user = Auth.auth().currentUser
        self.isSignedIn = self.user != nil
        self.userId = self.user?.uid

        if let uid = self.userId {
            fetchUserData(uid: uid)
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isSignedIn = false
            self.userId = nil
            self.myUser = MyUser()
            self.isLoggedIn = false
        } catch {
            print("Sign Out Error: \(error.localizedDescription)")
        }
        
    }

    func signIn() async {
        do {
            _ = try await Auth.auth().signIn(
                withEmail: myUser.email,
                password: myUser.password
            )

            await MainActor.run {
                self.falseCredential = false
                self.checkUserSession()
            }
        } catch {
            await MainActor.run {
                self.falseCredential = true
            }
        }
        self.isLoggedIn = true
    }

    func signUp() async {
        do {
            let result = try await Auth.auth().createUser(
                withEmail: myUser.email,
                password: myUser.password
            )

            let uid = result.user.uid

            let userData: [String: Any] = [
                "uuid": uid,
                "email": myUser.email,
                "password": myUser.password,
                "age": myUser.age
            ]

            try await dbRef.child("users").child(uid).setValue(userData)

            await MainActor.run {
                self.falseCredential = false
                self.checkUserSession()
            }

        } catch {
            await MainActor.run {
                self.falseCredential = true
            }
        }
    }

    func fetchUserData(uid: String) {
        dbRef.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else { return }

            let user = MyUser(
                uuid: uid,
                email: value["email"] as? String ?? "",
                password: value["password"] as? String ?? "",
                age: value["age"] as? Int ?? 0
            )

            DispatchQueue.main.async {
                self.myUser = user
            }
        }
    }

    func updateUser(email: String? = nil, password: String? = nil, age: Int? = nil) async {
        guard let user = Auth.auth().currentUser, let uid = self.userId else { return }
        
        do {
            var updates: [String: Any] = [:]
            
            // Update email if provided
            if let newEmail = email {
                try await user.updateEmail(to: newEmail)
                updates["email"] = newEmail
                await MainActor.run {
                    self.myUser.email = newEmail
                }
            }
            
            // Update password if provided
            if let newPassword = password {
                try await user.updatePassword(to: newPassword)
                updates["password"] = newPassword
                await MainActor.run {
                    self.myUser.password = newPassword
                }
            }
            
            // Update age if provided
            if let newAge = age {
                updates["age"] = newAge
                await MainActor.run {
                    self.myUser.age = newAge
                }
            }
            
            // Update Firebase Database with all changes
            if !updates.isEmpty {
                try await dbRef.child("users").child(uid).updateChildValues(updates)
            }
            
        } catch {
            print("Update error: \(error.localizedDescription)")
        }
    }

    func deleteUser() async {
        guard let user = Auth.auth().currentUser else { return }

        let uid = user.uid

        do {
            try await dbRef.child("users").child(uid).removeValue()
            try await user.delete()

            await MainActor.run {
                self.user = nil
                self.myUser = MyUser()
                self.isSignedIn = false
                self.userId = nil
            }

        } catch {
            print("Delete error: \(error.localizedDescription)")
        }
    }

    func fetchAllUsers(completion: @escaping ([MyUser]) -> Void) {
        dbRef.child("users").observeSingleEvent(of: .value) { snapshot in
            var result: [MyUser] = []
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any] {

                    let user = MyUser(
                        uuid: snap.key,
                        email: value["email"] as? String ?? "",
                        password: value["password"] as? String ?? "",
                        age: value["age"] as? Int ?? 0
                    )
                    result.append(user)
                }
            }
            completion(result)
        }
    }
}
