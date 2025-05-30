//
//  ReplyModel.swift
//  AlpMAD
//
//  Created by student on 22/05/25.
//

import Foundation
import FirebaseDatabase

struct Reply: Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    var postId: String
    var content: String
    var timestamp: Date

    var toDict: [String: Any] {
        return [
            "id": id,
            "postId": postId,
            "content": content,
            "timestamp": timestamp.timeIntervalSince1970
        ]
    }

    static func fromDict(_ dict: [String: Any]) -> Reply? {
        guard
            let id = dict["id"] as? String,
            let postId = dict["postId"] as? String,
            let content = dict["content"] as? String,
            let timestamp = dict["timestamp"] as? TimeInterval
        else {
            return nil
        }

        return Reply(id: id, postId: postId, content: content, timestamp: Date(timeIntervalSince1970: timestamp))
    }
}
