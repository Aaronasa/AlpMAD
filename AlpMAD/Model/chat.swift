//
//  chat.swift
//  AlpMAD
//
//  Created by student on 22/05/25.
//

import Foundation

struct Chat: Hashable, Codable, Identifiable {
    var id: String // For use in ForEach
    var chatId: String
    var message: String
    var time: Date
    var senderId: String
    var receiveId: String
}

