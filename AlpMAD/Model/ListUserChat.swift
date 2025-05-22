//
//  ListUserChat.swift
//  AlpMAD
//
//  Created by student on 22/05/25.
//

import Foundation
struct ListUserChat: Hashable, Codable, Identifiable {
    var id: String
    var listUserId: String
    var username: String
    var lastMessage: Chat
}
