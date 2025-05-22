//
//  ReplyViewModel.swift
//  AlpMAD
//
//  Created by student on 22/05/25.
//

import Foundation
import FirebaseDatabase
import Combine
import CoreML

// Shared vocabulary and bad word list
let replyVocabulary: [String: Int] = [
    "saya": 1,
    "senang": 2,
    "sedih": 3,
    "marah": 4,
    "bodoh": 5,
    "jelek": 6,
    "bagus": 7,
    "buruk": 8,
    "cinta": 9,
    "benci": 10,
    // Tambahkan lebih banyak jika perlu
]

let replyBadWords: Set<String> = [
    "bodoh", "jelek", "buruk", "benci"
]

class ReplyViewModel: ObservableObject {
    @Published var replies: [Reply] = []
    @Published var newReplyText: String = ""
    @Published var replyError: String? = nil

    private var dbRef = Database.database().reference()
    private let sentimentModel = try? SentimentAnalysis(configuration: MLModelConfiguration())

    // MARK: - Fetch
    func fetchReplies(for postId: String) {
        dbRef.child("replies").child(postId).observe(.value) { snapshot in
            var loadedReplies: [Reply] = []
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? [String: Any],
                   let reply = Reply.fromDict(dict) {
                    loadedReplies.append(reply)
                }
            }

            DispatchQueue.main.async {
                self.replies = loadedReplies.sorted { $0.timestamp > $1.timestamp }
            }
        }
    }

    // MARK: - Post
    func postReply(to postId: String) {
        let trimmed = newReplyText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        // 1. Cek kata kasar
        if containsBadWords(trimmed) {
            replyError = "The reply was rejected because it contained inappropriate word."
            return
        }

        // 2. Analisis sentimen
        guard let score = analyzeSentimentScore(for: trimmed), score >= 0.3 else {
            replyError = "The reply content is too negative. Score:\(analyzeSentimentScore(for: trimmed) ?? 0)"
            return
        }

        // 3. Simpan balasan
        let reply = Reply(postId: postId, content: trimmed, timestamp: Date())
        let replyRef = dbRef.child("replies").child(postId).child(reply.id)
        replyRef.setValue(reply.toDict)

        newReplyText = ""
        replyError = nil
    }

    func replies(for postId: String) -> [Reply] {
        replies.filter { $0.postId == postId }
    }

    // MARK: - NLP Filtering

    private func containsBadWords(_ text: String) -> Bool {
        let words = text.lowercased().split(separator: " ").map { String($0) }
        for word in words {
            let clean = word.trimmingCharacters(in: .punctuationCharacters)
            if replyBadWords.contains(clean) {
                return true
            }
        }
        return false
    }

    private func tokenize(_ text: String) -> MLMultiArray? {
        let maxLength = 10000
        let tokens = text.lowercased().split(separator: " ").map { String($0) }

        var inputArray = [NSNumber](repeating: 0, count: maxLength)
        for i in 0..<min(tokens.count, maxLength) {
            inputArray[i] = NSNumber(value: replyVocabulary[tokens[i]] ?? 0)
        }

        guard let mlArray = try? MLMultiArray(shape: [1, NSNumber(value: maxLength)], dataType: .float32) else {
            return nil
        }

        for (i, value) in inputArray.enumerated() {
            mlArray[i] = value
        }

        return mlArray
    }

    private func analyzeSentimentScore(for text: String) -> Float? {
        guard let inputArray = tokenize(text),
              let output = try? sentimentModel?.prediction(dense_1_input: inputArray),
              output.Identity.count > 0 else {
            return nil
        }
        return output.Identity[0].floatValue
    }
}


extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

