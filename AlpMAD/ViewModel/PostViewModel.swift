//
//  PostViewModel.swift
//  AlpMAD
//
//  Created by Aaron Asa Soelistiono on 19/05/25.
//
import Foundation
import FirebaseDatabase
import FirebaseAuth
import CoreML

let vocabulary: [String: Int] = [
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
]

// List of bad words to filter
let badWords: Set<String> = [
    "bodoh",
    "jelek",
    "buruk",
    "benci",
    // Add more bad words here as needed
]

class PostViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var userPosts = [Post]()
    @Published var postError: String? = nil
    
    private var ref: DatabaseReference
    private let sentimentModel = try? SentimentAnalysis(configuration: MLModelConfiguration())
    
    init() {
        self.ref = Database.database().reference().child("posts")
        fetchAllPosts()
    }
    
    private func tokenize(_ text: String) -> MLMultiArray? {
        let maxLength = 10000 // harus sama seperti input model
        let tokens = text.lowercased().split(separator: " ").map { String($0) }

        var inputArray = [NSNumber](repeating: 0, count: maxLength)
        for i in 0..<min(tokens.count, maxLength) {
            inputArray[i] = NSNumber(value: vocabulary[tokens[i]] ?? 0)
        }

        guard let mlArray = try? MLMultiArray(shape: [1, NSNumber(value: maxLength)], dataType: .float32) else {
            return nil
        }

        for (index, value) in inputArray.enumerated() {
            mlArray[index] = value
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
    
    // Check if text contains any bad words
    private func containsBadWords(_ text: String) -> Bool {
        let words = text.lowercased().split(separator: " ").map { String($0) }
        // Also check for bad words that might be part of larger words
        for word in words {
            let cleanWord = word.trimmingCharacters(in: .punctuationCharacters)
            if badWords.contains(cleanWord) {
                return true
            }
        }
        return false
    }

    
    func fetchAllPosts() {
        ref.observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                self.posts = []
                return
            }
            
            self.posts = value.compactMap { _, postData in
                guard let postDict = postData as? [String: Any],
                      let jsonData = try? JSONSerialization.data(withJSONObject: postDict),
                      let model = try? JSONDecoder().decode(Post.self, from: jsonData)
                else {
                    return nil
                }
                return model
            }.sorted(by: { $0.timestamp > $1.timestamp })
        }
    }
    
    func fetchUserPosts() {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.userPosts = []
            return
        }
        
        ref.observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                self.userPosts = []
                return
            }
            
            self.userPosts = value.compactMap { _, postData in
                guard let postDict = postData as? [String: Any],
                      let jsonData = try? JSONSerialization.data(withJSONObject: postDict),
                      let model = try? JSONDecoder().decode(Post.self, from: jsonData),
                      model.userId == uid
                else {
                    return nil
                }
                return model
            }.sorted(by: { $0.timestamp > $1.timestamp })
        }
    }
    
    func addPost(content: String) -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else {
            postError = "User tidak terautentikasi"
            return false
        }
        
        if containsBadWords(content) {
            postError = "Post ditolak karena mengandung kata-kata yang tidak pantas"
            return false
        }
        
        // Then check sentiment score as a second layer of filtering
        guard let score = analyzeSentimentScore(for: content), score >= 0.3 else {
            postError = "Konten terlalu negatif. Skor: \(analyzeSentimentScore(for: content) ?? 0)"
            return false
        }
        
        let postId = UUID().uuidString
        
        let post = Post(
            id: postId,
            userId: uid,
            content: content,
            timestamp: Date(),
            commentCount: 0,
            likeCount: 0
        )
        
        guard let jsonData = try? JSONEncoder().encode(post),
              let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
        else {
            postError = "Gagal mengkonversi data post"
            return false
        }
        
        ref.child(postId).setValue(json)
        postError = nil
        return true
    }
    
    func updatePost(_ post: Post) -> Bool {
        if containsBadWords(post.content) {
            postError = "Update ditolak karena mengandung kata-kata yang tidak pantas"
            return false
        }
        
        guard let uid = Auth.auth().currentUser?.uid,
              post.userId == uid,
              let jsonData = try? JSONEncoder().encode(post),
              let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
        else {
            postError = "Gagal mengupdate post"
            return false
        }
        
        ref.child(post.id).setValue(json)
        postError = nil
        return true
    }
    
    func deletePost(_ post: Post) {
        guard let uid = Auth.auth().currentUser?.uid,
              post.userId == uid
        else { return }
        
        ref.child(post.id).removeValue()
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { i in
            let post = posts[i]
            deletePost(post)
        }
    }
    
    func likePost(_ post: Post) {
        let likeRef = ref.child(post.id).child("likeCount")
        likeRef.runTransactionBlock { currentData in
            var count = currentData.value as? Int ?? 0
            count += 1
            currentData.value = count
            return .success(withValue: currentData)
        }
    }

    func unlikePost(_ post: Post) {
        let likeRef = ref.child(post.id).child("likeCount")
        likeRef.runTransactionBlock { currentData in
            var count = currentData.value as? Int ?? 0
            count = max(0, count - 1)
            currentData.value = count
            return .success(withValue: currentData)
        }
    }
    
}
