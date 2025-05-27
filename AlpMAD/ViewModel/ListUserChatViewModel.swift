//
//  ListUserChatViewModel.swift
//  AlpMAD
//
//  Created by student on 27/05/25.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class ListUserChatViewModel: ObservableObject {
    @Published var listUserChats: [ListUserChat] = []
    
    private var ref: DatabaseReference = Database.database().reference().child("chats")
    
    func fetchUserChats() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        ref.observe(.value) { snapshot in
            var result: [ListUserChat] = []
            
            for child in snapshot.children {
                guard let snap = child as? DataSnapshot else { continue }
                
                let chatId = snap.key
                let users = chatId.split(separator: "_").map(String.init)
                
                // Only include chat if current user is one of the participants
                guard users.contains(currentUserId), users.count == 2 else { continue }
                
                let otherUserId = users.first { $0 != currentUserId } ?? ""
                
                // Get last message from the chat
                var messages: [Chat] = []
                
                for messageSnap in snap.children {
                    guard let messageNode = messageSnap as? DataSnapshot,
                          let dict = messageNode.value as? [String: Any],
                          let jsonData = try? JSONSerialization.data(withJSONObject: dict),
                          let message = try? JSONDecoder().decode(Chat.self, from: jsonData)
                    else { continue }
                    
                    messages.append(message)
                }
                
                if let lastMessage = messages.sorted(by: { $0.time > $1.time }).first {
                    let listUserChat = ListUserChat(
                        id: UUID().uuidString,
                        listUserId: otherUserId,
                        username: otherUserId, // You can replace this with a call to get the username if you store that elsewhere
                        lastMessage: lastMessage
                    )
                    result.append(listUserChat)
                }
            }
            
            self.listUserChats = result.sorted(by: { $0.lastMessage.time > $1.lastMessage.time })
        }
    }
}
