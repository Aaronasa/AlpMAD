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
    "oon", "telmi", "dodol", "bahul", "bahlul", "pandir", "bebal", "pekok",
    "pethuk", "kemplu", "geblek", "bongak", "ogeb", "bento",
    "anjing", "anjir", "anjrit", "anjrot", "ajg", "anjg", "asu", "anjinglah",
    "anjingnya", "njing", "njir", "gukguk",
    "bangsat", "bangke", "bgsd", "bgst", "bangsul", "bajingan",
    "brengsek", "berengsek",
    "kampret", "kampang", "sompret", "semprul",
    "keparat", "kprt",
    "setan", "syaiton", "iblis", "dajal", "laknat", "laknatullah", "celaka",
    "sialan",
    "jancuk", "jancok", "cuk", "cok", "dancuk", "jncq", "cukimai", "cukimay",
    "coeg",
    "jembut", "jembud", "jmbrt", "bulu jembut",
    "pantek", "pante", "pntk", "kimak", "pukimak", "puki", "pukima",
    "tai", "taik", "taek", "eek", "taikucing", "tahi",
    "bedebah", "biadab", "celeng", "monyet", "kunyuk", "bedes", "jalak",
    "kadal", "kebo", "wedhus", "buaya", "ular", "kutu", "kutukupret",
    "babi", "bagong",
    "gblk", "gblg",
    "tll",
    "hina", "nista", "bejad", "berandal", "brandal",
    "mampus", "modar", "matek",
    "jahanam", "jahannam",
    "kepala batu", "otak udang", "otak geser", "otak kosong", "gak ada otak",
    "gak punya otak",
    "sampah", "sampah masyarakat",
    "songong", "belagu", "sombong", "congkak",
    "sontoloyo", "sinting", "sinting miring", "sarap", "saraf", "gendeng",
    "edan", "geloh",
    "bangor", "benges", "bokis", "boncos", "bonyok", "cebol", "congok", "cupu",
    "kacrut", "kuper", "leco", "maho", "nggateli", "preman", "rempong",
    "slengean", "tengik", "udik", "kerepotan",
    "jijik", "najis", "muak",
    "ngehek", "sial", "apes", "cilaka",
    "kopet", "setund",
    "kontol", "kntl", "kn_tl", "peli", "pler", "peler",
    "memek", "memk", "mmk", "meki", "itil", "turuk", "pepek", "tempek",
    "dompet", "kipo",
    "ngentot", "entot", "ewe", "ngewe", "kenthu", "ngeseks", "indehoi", "zina",
    "kumpul kebo",
    "pecun", "perek", "lonte", "pelacur", "jablay", "psk", "sundal", "bispak",
    "kimcil", "cabe-cabean", "jalang", "murahan", "gampangan", "open bo",
    "bokep", "porno", "seks", "mesum", "asusila", "syahwat", "birahi", "sange",
    "konak", "ngaceng",
    "colmek", "coli", "ngocok", "masturbasi", "onani",
    "gigolo", "simpanan", "mucikari", "germo",
    "nude", "bugil", "telanjang",
    "penis", "vagina", "payudara", "tetek", "toket", "pentil", "buah dada",
    "alat kelamin", "kelamin", "selangkangan",
    "peju", "sperma", "mani", "crot", "crotdi", "lendir",
    "sepong", "bokong",
    "kamasutra",
    "pukul", "hantam", "hajar", "gebuk", "gampar", "tabok", "tampar", "kepruk",
    "tampol", "bogem",
    "bantai", "bantaian",
    "bunuh", "habisi", "gorok", "sembelih", "ganyang", "lumat",
    "bacok", "tebas",
    "bakar",
    "tusuk", "tikam",
    "serang", "serbuan", "gempur",
    "injak", "lindas",
    "lempar", "timpuk",
    "tendang",
    "rampok", "begal", "jarah",
    "mutilasi",
    "penggal",
    "tembak",
    "perkosa",
    "gebukin", "hancurkan", "musnahkan", "lenyapkan",
    "gila", "sinting", "edan", "sarap", "saraf", "mental", "tak waras",
    "psycho", "abnormal", "sableng", "gendeng", "stres", "depresi",
    "cacat", "pincang", "cebol", "sumbing", "bisu", "tuli", "buta", "mandul",
    "lemah", "gagal", "pecundang", "payah",
    "gendut", "gembrot", "gendut banget", "obesitas", "bongsor", "buntal",
    "kerempeng", "ceking", "kurus kering", "krempeng",
    "jelek", "burik", "dekil", "kucel", "pesek", "tonggos", "bopeng", "jenong",
    "mancung",
    "item", "hitam", "buluk", "kusam", "ireng",
    "muka dua", "muka jelek", "jerawatan", "bau", "cemong", "miring",
    "mukanya miring", "kempot", "botak", "kriting",
    "dempul", "belobor", "gembil", "gombrang", "gombrong",
    "kafir", "kapir", "kufur",
    "murtad", "murtadin",
    "bidah", "bid'ah",
    "sesat", "ajaran sesat",
    "penista", "penista agama",
    "laknat", "laknatullah",
    "syirik", "musyrik",
    "neraka", "jahannam", "jahanam",
    "taghut", "zindik", "fasik", "munafik", "zalim",
    "iluminati", "freemason",
    "rasis", "rasisme",
    "cina", "cino", "cokin", "aseng", "sipit",
    "pribumi", "non-pribumi", "pri", "nonpri",
    "negro", "nigga", "negrito", "keling",
    "onta",
    "indon",
    "islam radikal", "yahudi laknat", " Kristen radikal", "Hindu garis keras",
    "komunis", "pki", "komunisme",
    "kadrun", "cebong", "kampret",
    "antek",
    "asing",
    "norak", "alay", "kampungan", "murahan", "rendahan", "culun", "ndeso",
    "katrok", "udik", "primitif",
    "sok tau", "sotoy", "sok pintar", "sok iye", "sok alim", "sok suci",
    "sok jago", "sok kaya", "sok cantik", "sok ganteng", "sok",
    "tukang fitnah", "fitnah", "tukang adu domba", "adu domba",
    "cari muka", "caper", "penjilat", "menjilat",
    "provokator", "biang kerok", "perusuh", "pengacau",
    "serakah", "rakus", "tamak", "loba", "mata duitan", "matre", "koruptor",
    "korup",
    "pemalas", "malas",
    "curang", "licik", "culas",
    "penipu", "pembohong", "tukang bohong", "ngibul", "kibul", "bokis",
    "gadungan",
    "pengkhianat", "khianat",
    "parasit", "benalu", "sampah",
    "pengemis", "gembel", "kere", "miskin", "fakir",
    "pengganggu",
    "bocah", "bocil",
    "numpang hidup",
    "tukang komplain", "drama queen", "ratu drama", "raja drama",
    "munafik", "hipokrit",
    "pengecut",
    "jahat", "kejam", "sadis", "bengis",
    "banci", "bencong", "waria", "ladyboy",
    "homo", "lesbi", "gay", "lgbt",
    "nyebelin", "ngeselin", "rese", "resek", "malesin", "bt", "bete", "gangguk",
    "usik", "usil",
    "omong kosong", "bacot", "bct", "congor",
    "tak berguna", "ga guna", "sia-sia", "percuma",
    "bodo amat", "bomat", "bodo ah", "emang gue pikirin", "egp",
    "ga penting", "gak penting",
    "gajelas", "gak jelas", "gj", "absurd", "aneh",
    "gtw", "gatau",
    "wibu", "jejepangan",
    "lebay", "hiperbola",
    "toxic", "toksik",
    "kurang ajar", "tidak sopan", "durhaka",
    "bawel", "cerewet", "berisik", "nyinyir", "julid", "lambe turah",
    "kepo", "pengen tahu",
    "labil", "plinplan",
    "manja", "cengeng", "rewel",
    "medit", "pelit", "kikir",
    "muka tembok", "gak punya malu", "tebal muka",
    "narsis", "narsistik", "egois", "egoisme",
    "ngotot", "keras kepala", "ngeyel",
    "oportunis",
    "pansos", "haus pujian", "gila hormat", "gila pujian",
    "picik", "sempit pikiran",
    "plagiat",
    "sengak", "tengil", "songong", "sombong",
    "sirik", "dengki", "iri",
    "sumbang", "janggal",
    "urakan", "barbar",
    "bolot", "budek", "congek",
    "clingak-clinguk", "grusak-grusuk", "grasak-grusuk",
    "jaim",
    "katrok",
    "kecentilan", "ganjen", "centil",
    "kolot",
    "pengadu",
    "ngeyel",
    "mati aja lo", "mampus lo", "modar lo",
    "pergi ke neraka", "ke neraka saja kau",
    "dasar",
    "gak becus", "tidak becus",
    "gobloknya minta ampun", "bodohnya kebangetan",
    "apaan sih", "apaan coba",
    "bullshit", "omdo",
    "fuck", "shit", "damn", "bitch", "asshole", "motherfucker", "wtf", "lmao",
    "lol","anjink", "anjim", "ajgwm", "ajgm","bgke", "bngst","cntl", "kntd", "k0nt0l", "k0ntl",
    "mmk", "m3m3k", "m3mk",
    "ngntd", "ngent0t", "ngewe",
    "sangean", "sangenan",
    "syaland",
    "typo",
    "hode",
    "noob", "newbie",
    "plonco",
    "halu", "halusinasi",
    "receh",
    "unfaedah", "gafaedah", "gak faedah",
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
        let lowercasedText = text.lowercased()
        let words = lowercasedText.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        
        for word in words {
            // Clean the word from punctuation
            let cleanWord = word.trimmingCharacters(in: .punctuationCharacters)
            
            // Skip empty strings
            if cleanWord.isEmpty {
                continue
            }
            
            // Check exact match with bad words
            if badWords.contains(cleanWord) {
                print("Found bad word: \(cleanWord)")
                return true
            }
        }
         for badWord in badWords {
             if lowercasedText.contains(badWord) {
                 print("Found bad word as substring: \(badWord)")
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

        // Trim whitespace and check if content is empty
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedContent.isEmpty {
            postError = "Konten tidak boleh kosong"
            return false
        }

        // Check for bad words first
        if containsBadWords(trimmedContent) {
            postError = "Post ditolak karena mengandung kata-kata yang tidak pantas"
            return false
        }

        // Check sentiment score - make this optional or more lenient
        if let score = analyzeSentimentScore(for: trimmedContent) {
            print("Sentiment score: \(score)")
            // Lower the threshold or make it optional
            if score < 0.1 { // Lowered from 0.3 to 0.1
                postError = "Konten terlalu negatif. Skor: \(score)"
                return false
            }
        } else {
            // If sentiment analysis fails, allow the post
            print("Sentiment analysis failed, allowing post")
        }

        let postId = UUID().uuidString

        let post = Post(
            id: postId,
            userId: uid,
            content: trimmedContent,
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
        let trimmedContent = post.content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if containsBadWords(trimmedContent) {
            postError = "Update ditolak karena mengandung kata-kata yang tidak pantas"
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
