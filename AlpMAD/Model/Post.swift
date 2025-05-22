//
//  Post.swift
//  AlpMAD
//
//  Created by Aaron Asa Soelistiono on 18/05/25.
//

import Foundation

struct Post: Identifiable, Hashable, Codable {
    var id: String
    var userId: String
    var content: String
    var timestamp: Date
    var commentCount: Int = 0
    var likeCount: Int = 0
    
    var likedByCurrentUser: Bool?
}
