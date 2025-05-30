//
//  ListUserChatViewModel.swift
//  AlpMAD
//
//  Created by student on 30/05/25.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class ListUserChatViewModel: ObservableObject {
    @Published var userChats: [ListUserChat] = []
    
    private var ref: DatabaseReference = Database.database().reference()
    private var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }

    func fetchChats() {
        guard let currentUserId = currentUserId else { return }

        ref.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let usersDict = snapshot.value as? [String: [String: Any]] else { return }

            var fetchedChats: [ListUserChat] = []

            let group = DispatchGroup()

            for (userId, userInfo) in usersDict {
                guard userId != currentUserId,
                      let username = userInfo["username"] as? String else { continue }

                let chatId = self.generateChatId(user1: currentUserId, user2: userId)
                group.enter()

                self.ref.child("chats").child(chatId).observeSingleEvent(of: .value) { chatSnapshot in
                    let messages = chatSnapshot.children.allObjects.compactMap { child -> Chat? in
                        guard let snap = child as? DataSnapshot,
                              let value = snap.value as? [String: Any],
                              let jsonData = try? JSONSerialization.data(withJSONObject: value),
                              let chat = try? JSONDecoder().decode(Chat.self, from: jsonData) else { return nil }
                        return chat
                    }

                    if let lastMessage = messages.sorted(by: { $0.time > $1.time }).first {
                        let userChat = ListUserChat(id: UUID().uuidString, listUserId: userId, username: username, lastMessage: lastMessage)
                        fetchedChats.append(userChat)
                    }

                    group.leave()
                }
            }

            group.notify(queue: .main) {
                self.userChats = fetchedChats.sorted(by: { $0.lastMessage.time > $1.lastMessage.time })
            }
        }
    }

    private func generateChatId(user1: String, user2: String) -> String {
        return [user1, user2].sorted().joined(separator: "_")
    }
}

