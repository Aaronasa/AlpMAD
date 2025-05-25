import CoreML
import FirebaseAuth
import FirebaseDatabase
//
//  PostViewModel.swift
//  AlpMAD
//
//  Created by Aaron Asa Soelistiono on 19/05/25.
//
import Foundation

let badWords: Set<String> = [
    "bodoh", "tolol", "goblok", "bego", "idiot", "dungu", "lemot", "bloon",
    "anjing", "bangsat", "brengsek", "kampret", "keparat", "setan", "iblis",
    "jancuk", "jembut", "pantek", "tai", "taik", "bajingan", "kontol", "memek",
    "ngentot", "pecun", "perek", "lonte", "pelacur", "jablay", "psk", "pelakor",
    "tukang selingkuh", "cok", "jancok",
    "pukul", "bantai", "bunuh", "bacok", "bakar", "tusuk", "serang", "injak",
    "lempar", "tendang",
    "habisi", "rampok", "mutilasi", "penjarakan", "torture", "penggal",
    "tembak",
    "bokep", "porno", "seks", "mesum", "colmek", "coli", "masturbasi", "ngocok",
    "ngentot",
    "penis", "vagina", "payudara", "tetek", "ewe", "nude", "gila", "sinting",
    "mental", "tak waras", "psycho", "abnormal", "cacat", "pincang", "idiot",
    "lemah", "gagal", "nyebelin", "ngeselin", "omong kosong", "tak berguna",
    "pengganggu", "beban",
    "gendut", "gendut banget", "obesitas", "kerempeng", "jelek", "burik",
    "dekil", "item", "hitam",
    "muka dua", "muka jelek", "jerawatan", "bau", "dekil", "cemong", "miring",
    "mukanya miring",
    "kafir", "murtad", "bidah", "sesat", "penista", "laknat", "syirik",
    "neraka", "laknatullah",
    "rasis", "cina", "pribumi", "non-pribumi", "negro", "arab jelek",
    "islam radikal", "yahudi laknat",
    "norak", "alay", "kampungan", "murahan", "rendahan", "lemot", "culun",
    "sok tau", "sok pintar",
    "tukang fitnah", "tukang adu domba", "cari muka", "provokator", "serakah",
    "mata duitan",
    "pemalas", "curang", "penipu", "pembohong", "pengkhianat", "parasit",
    "benalu", "sampah",
    "pengemis", "pengganggu", "bocah", "numpang hidup", "tukang komplain",
    "drama queen",
    "anjir", "anjrit", "anjrot", "bangke", "bangsat", "kntl", "memk", "njir",
    "njing", "pntk", "kntl", "ajg", "anjg","cino", 
    "tai lah", "tai banget", "bodo amat", "bodo ah", "ga penting", "gajelas",
    "gtw", "wibu", "bacot",
    "resek", "rese", "lebay", "malesin", "bt", "toxic", "kampungan", "sok iye",
    "sotoy",
]

class PostViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var userPosts = [Post]()
    @Published var postError: String? = nil

    private var repliesRef: DatabaseReference
    private var ref: DatabaseReference
    private let sentimentModel = try? SentimentAnalysis(
        configuration: MLModelConfiguration()
    )

    init() {
        self.ref = Database.database().reference().child("posts")
        self.repliesRef = Database.database().reference().child("replies")
        fetchAllPosts()
    }

    private let tokenizer = Tokenizer(filename: "tokenizer")

    private func tokenize(_ text: String) -> MLMultiArray? {
        let maxLength = 10000
        guard let tokenIds = tokenizer?.encode(text, maxLength: maxLength)
        else {
            return nil
        }

        guard
            let mlArray = try? MLMultiArray(
                shape: [1, NSNumber(value: maxLength)],
                dataType: .float32
            )
        else {
            return nil
        }

        for (index, value) in tokenIds.enumerated() {
            mlArray[index] = NSNumber(value: value)
        }

        return mlArray
    }

    private func analyzeSentimentScore(for text: String) -> Float? {
        guard let inputArray = tokenize(text),
            let output = try? sentimentModel?.prediction(
                dense_1_input: inputArray
            ),
            output.Identity.count > 0
        else {
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
                    let jsonData = try? JSONSerialization.data(
                        withJSONObject: postDict
                    ),
                    let model = try? JSONDecoder().decode(
                        Post.self,
                        from: jsonData
                    )
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
                    let jsonData = try? JSONSerialization.data(
                        withJSONObject: postDict
                    ),
                    let model = try? JSONDecoder().decode(
                        Post.self,
                        from: jsonData
                    ),
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
            postError =
                "Post ditolak karena mengandung kata-kata yang tidak pantas"
            return false
        }

        guard let score = analyzeSentimentScore(for: content), score >= 0.3
        else {
            postError =
                "Konten mengandung kata-kata negatif. Skor: \(analyzeSentimentScore(for: content) ?? 0)"
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
            let json = try? JSONSerialization.jsonObject(with: jsonData)
                as? [String: Any]
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
            postError =
                "Update ditolak karena mengandung kata-kata yang tidak pantas"
            return false
        }

        guard let uid = Auth.auth().currentUser?.uid,
            post.userId == uid,
            let jsonData = try? JSONEncoder().encode(post),
            let json = try? JSONSerialization.jsonObject(with: jsonData)
                as? [String: Any]
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

    func syncAllCommentCounts() {
        for post in posts {
            syncCommentCount(for: post.id)
        }
    }

    func syncCommentCount(for postId: String) {
        repliesRef.child(postId).observeSingleEvent(of: .value) {
            [weak self] snapshot in
            let actualCount = Int(snapshot.childrenCount)
            self?.ref.child(postId).child("commentCount").setValue(actualCount)
        }
    }
}
