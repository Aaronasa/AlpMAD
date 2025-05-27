//
//  ReplyModel.swift
//  AlpMAD
//
//  Created by student on 22/05/25.
//

import FirebaseDatabase
import Foundation

struct ReplyModel: Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    var userId: String
    var postId: String
    var content: String
    var timestamp: Date
}
