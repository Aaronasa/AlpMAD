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
import FirebaseAuth

let badWord: Set<String> = [
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


class ReplyViewModel: ObservableObject {
    @Published var replies: [ReplyModel] = []
    @Published var newReplyText: String = ""
    @Published var replyError: String? = nil
    @Published var userReplies: [ReplyModel] = []
    @Published var editedContent: String = ""
    @Published var errorMessage: String? = nil
    
    private var dbRef = Database.database().reference()
    private let sentimentModel = try? SentimentAnalysis(configuration: MLModelConfiguration())
    private let tokenizer = Tokenizer(filename: "tokenizer")

    private func tokenize(_ text: String) -> MLMultiArray? {
        let maxLength = 10000
        guard let tokenIds = tokenizer?.encode(text, maxLength: maxLength) else {
            return nil
        }

        guard let mlArray = try? MLMultiArray(shape: [1, NSNumber(value: maxLength)], dataType: .float32) else {
            return nil
        }

        for (index, value) in tokenIds.enumerated() {
            mlArray[index] = NSNumber(value: value)
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

    private func containsBadWords(_ text: String) -> Bool {
        let lowercasedText = text.lowercased()
        let words = lowercasedText.components(separatedBy: CharacterSet.whitespacesAndNewlines)

        for word in words {
            let cleanWord = word.trimmingCharacters(in: .punctuationCharacters)
            if cleanWord.isEmpty { continue }
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

    func fetchReplies(for postId: String) {
        dbRef.child("replies").child(postId).observe(.value) { [weak self] snapshot in
            var loadedReplies: [ReplyModel] = []
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? [String: Any],
                   let jsonData = try? JSONSerialization.data(withJSONObject: dict),
                   let reply = try? JSONDecoder().decode(ReplyModel.self, from: jsonData) {
                    loadedReplies.append(reply)
                }
            }

            DispatchQueue.main.async {
                self?.replies = loadedReplies.sorted { $0.timestamp > $1.timestamp }
            }
        }
    }

    func fetchUserReplies() {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.userReplies = []
            return
        }

        dbRef.child("replies").observeSingleEvent(of: .value) { [weak self] snapshot in
            var userReplyList: [ReplyModel] = []

            for child in snapshot.children {
                guard let postSnapshot = child as? DataSnapshot else { continue }

                for replyChild in postSnapshot.children {
                    guard let replySnap = replyChild as? DataSnapshot,
                          let dict = replySnap.value as? [String: Any] else { continue }

                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: dict)
                        let reply = try JSONDecoder().decode(ReplyModel.self, from: jsonData)

                        if reply.userId == uid {
                            userReplyList.append(reply)
                        }
                    } catch {
                        print("Error decoding reply: \(error)")
                    }
                }
            }

            DispatchQueue.main.async {
                self?.userReplies = userReplyList.sorted { $0.timestamp > $1.timestamp }
            }
        }
    }

    func postReply(to postId: String) -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else {
            replyError = "User not authenticated"
            return false
        }

        let trimmed = newReplyText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            replyError = "Reply can't be empty"
            return false
        }

        if containsBadWords(trimmed) {
            replyError = "Reply rejected because it contains inappropriate words"
            return false
        }

        if let score = analyzeSentimentScore(for: trimmed) {
            print("Sentiment score: \(score)")
            if score < 0.1 {
                replyError = "The reply content is too negative. Score: \(score)"
                return false
            }
        } else {
            print("Sentiment analysis failed, allowing reply")
        }

        let reply = ReplyModel(userId: userId, postId: postId, content: trimmed, timestamp: Date())

        do {
            let data = try JSONEncoder().encode(reply)
            guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                replyError = "Failed to convert reply data"
                return false
            }

            dbRef.child("replies").child(postId).child(reply.id).setValue(jsonObject)
            updatePostCommentCount(for: postId)

            DispatchQueue.main.async {
                self.newReplyText = ""
                self.replyError = nil
            }

            return true
        } catch {
            replyError = "Failed to encode reply data"
            return false
        }
    }

    private func updatePostCommentCount(for postId: String) {
        dbRef.child("replies").child(postId).observeSingleEvent(of: .value) { [weak self] snapshot in
            let actualCount = Int(snapshot.childrenCount)
            self?.dbRef.child("posts").child(postId).child("commentCount").setValue(actualCount)
        }
    }

    func syncCommentCount(for postId: String) {
        updatePostCommentCount(for: postId)
    }

    func replies(for postId: String) -> [ReplyModel] {
        return replies.filter { $0.postId == postId }
    }

    func updateReply(replyId: String, newContent: String, postId: String, completion: @escaping (Bool, String?) -> Void) {
        let trimmed = newContent.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            completion(false, "Reply can't be empty.")
            return
        }

        if badWords.contains(where: { trimmed.lowercased().contains($0) }) {
            completion(false, "Reply contains inappropriate word.")
            return
        }

        let ref = dbRef.child("replies").child(postId).child(replyId)
        ref.updateChildValues(["content": trimmed]) { error, _ in
            if let error = error {
                completion(false, "Failed to update reply: \(error.localizedDescription)")
            } else {
                completion(true, nil)
            }
        }
    }

    func saveChanges(replyId: String, postId: String, onSuccess: @escaping () -> Void) {
        let trimmed = editedContent.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            errorMessage = "Reply cannot be empty."
            return
        }

        if badWords.contains(where: { trimmed.lowercased().contains($0) }) {
            errorMessage = "Reply contains inappropriate word."
            return
        }

        let ref = dbRef.child("replies").child(postId).child(replyId)
        ref.updateChildValues(["content": trimmed]) { [weak self] error, _ in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Failed to update reply: \(error.localizedDescription)"
                } else {
                    if let index = self?.replies.firstIndex(where: { $0.id == replyId && $0.postId == postId }) {
                        self?.replies[index].content = trimmed
                    }
                    if let userIndex = self?.userReplies.firstIndex(where: { $0.id == replyId && $0.postId == postId }) {
                        self?.userReplies[userIndex].content = trimmed
                    }
                    
                    self?.errorMessage = nil
                    self?.editedContent = ""
                    onSuccess()
                }
            }
        }
    }

    func cancelEdit() {
        errorMessage = nil
        editedContent = ""
    }

    func deleteReply(_ reply: ReplyModel) {
        let replyRef = dbRef.child("replies").child(reply.postId).child(reply.id)
        replyRef.removeValue { [weak self] error, _ in
            if error == nil {
                self?.updatePostCommentCount(for: reply.postId)
            }
        }
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
