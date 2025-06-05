//
//  ChatViewModel.swift
//  AlpMAD
//
//  Created by student on 27/05/25.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

//membuat agar database bisa di coba dengan mock data
protocol DatabaseReferencing {
    func child(_ pathString: String) -> DatabaseReferencing
    func setValue(_ value: Any?)
}

//ini memungkinkan untuk menggunakan firebase protocol tanpa menghilangkan logic aslinya
class FirebaseDatabaseReferenceWrapper: DatabaseReferencing {
    private let reference: DatabaseReference

    init(reference: DatabaseReference) {
        self.reference = reference
    }

    func child(_ pathString: String) -> DatabaseReferencing {
        return FirebaseDatabaseReferenceWrapper(reference: reference.child(pathString))
    }

    func setValue(_ value: Any?) {
        reference.setValue(value)
    }
}


class ChatViewModel: ObservableObject {
    @Published var messages: [Chat] = []
    
    private var ref: DatabaseReferencing
    
    private var overrideUserId: String?
    
    init(overrideUserId: String? = nil, ref: DatabaseReferencing? = nil) {
        self.overrideUserId = overrideUserId
        self.ref = ref ?? FirebaseDatabaseReferenceWrapper(
            reference: Database.database().reference().child("chats")
        )
    }

    private var currentUserId: String? {
        return overrideUserId ?? Auth.auth().currentUser?.uid
    }
    
    func observeMessages(from senderId: String, to receiverId: String) {
        let chatId = generateChatId(user1: senderId, user2: receiverId)
        
        Database.database().reference().child("chats").child(chatId).observe(.value) { snapshot in
                    guard let value = snapshot.value as? [String: Any] else {
                        self.messages = []
                        return
                    }

                    self.messages = value.compactMap { _, chatData in
                        guard let dict = chatData as? [String: Any],
                              let jsonData = try? JSONSerialization.data(withJSONObject: dict),
                              let message = try? JSONDecoder().decode(Chat.self, from: jsonData)
                        else { return nil }
                        return message
                    }.sorted(by: { $0.time < $1.time }) // ascending by time
        }
    }
    
    func sendMessage(to receiverId: String, messageText: String) {
        guard let senderId = currentUserId else { return }
        
        let chatId = generateChatId(user1: senderId, user2: receiverId)
        let messageId = UUID().uuidString
        
        let message = Chat(
            id: messageId,
            chatId: chatId,
            message: messageText,
            time: Date(),
            senderId: senderId,
            receiveId: receiverId
        )
        
        guard let jsonData = try? JSONEncoder().encode(message),
              let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
        else { return }
        
        ref.child(chatId).child(messageId).setValue(json)
    }
    
    private func generateChatId(user1: String, user2: String) -> String {
        return [user1, user2].sorted().joined(separator: "_")
    }
    
    func isCurrentUser(_ message: Chat) -> Bool {
        return message.senderId == currentUserId
    }
}
