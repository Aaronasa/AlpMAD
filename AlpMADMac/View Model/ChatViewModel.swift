//
//  ChatViewModel.swift
//  AlpMAD
//
//  Created by student on 27/05/25.
//

import CoreML
import Foundation
import FirebaseAuth
import FirebaseDatabase


let badWordss: Set<String> = [
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
    "cuk",
    "noob", "newbie",
    "plonco",
    "halu", "halusinasi",
    "receh",
    "unfaedah", "gafaedah", "gak faedah",
]

//membuat agar database bisa di coba dengan mock data
protocol DatabaseReferencing {
    func child(_ pathString: String) -> DatabaseReferencing
    func setValue(_ value: Any?)
}

//ini memungkinkan untuk menggunakan firebase protocol tanpa menghilangkan logic aslinya
class FirebaseDatabaseReferenceWrapper: DatabaseReferencing {
    private let reference: DatabaseReference

    init(reference: DatabaseReference) {
        self.reference = reference
    }

    func child(_ pathString: String) -> DatabaseReferencing {
        return FirebaseDatabaseReferenceWrapper(reference: reference.child(pathString))
    }

    func setValue(_ value: Any?) {
        reference.setValue(value)
    }
}


class ChatViewModel: ObservableObject {
    @Published var messages: [Chat] = []
    @Published var chatError: IdentifiableString? = nil
    
    private var ref: DatabaseReferencing
    
    private var overrideUserId: String?
    
    init(overrideUserId: String? = nil, ref: DatabaseReferencing? = nil) {
        self.overrideUserId = overrideUserId
        self.ref = ref ?? FirebaseDatabaseReferenceWrapper(
            reference: Database.database().reference().child("chats")
        )
    }

    private var currentUserId: String? {
        return overrideUserId ?? Auth.auth().currentUser?.uid
    }
    
    func observeMessages(from senderId: String, to receiverId: String) {
        let chatId = generateChatId(user1: senderId, user2: receiverId)
        
        Database.database().reference().child("chats").child(chatId).observe(.value) { snapshot in
                    guard let value = snapshot.value as? [String: Any] else {
                        self.messages = []
                        return
                    }

                    self.messages = value.compactMap { _, chatData in
                        guard let dict = chatData as? [String: Any],
                              let jsonData = try? JSONSerialization.data(withJSONObject: dict),
                              let message = try? JSONDecoder().decode(Chat.self, from: jsonData)
                        else { return nil }
                        return message
                    }.sorted(by: { $0.time < $1.time }) // ascending by time
        }
    }
    
    func sendMessage(to receiverId: String, messageText: String) {
        guard let senderId = currentUserId else { return }
        
        if containsBadWords(messageText) {
            chatError = IdentifiableString(value: "Pesan mengandung kata yang tidak pantas untuk dikirim.")
            return
        }
        
        let chatId = generateChatId(user1: senderId, user2: receiverId)
        let messageId = UUID().uuidString
        
        let message = Chat(
            id: messageId,
            chatId: chatId,
            message: messageText,
            time: Date(),
            senderId: senderId,
            receiveId: receiverId
        )
        
        guard let jsonData = try? JSONEncoder().encode(message),
              let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
        else { return }
        
        ref.child(chatId).child(messageId).setValue(json)
    }
    
    private func generateChatId(user1: String, user2: String) -> String {
        return [user1, user2].sorted().joined(separator: "_")
    }
    
    func isCurrentUser(_ message: Chat) -> Bool {
        return message.senderId == currentUserId
    }
}

private func containsBadWords(_ text: String) -> Bool {
    let lowercasedText = text.lowercased()
    let words = lowercasedText.components(separatedBy: CharacterSet.whitespacesAndNewlines)
    
    for word in words {
        let cleanWord = word.trimmingCharacters(in: .punctuationCharacters)
        if cleanWord.isEmpty { continue }
        if badWordss.contains(cleanWord) {
            print("Found exact bad word: \(cleanWord)")
            return true
        }
    }

    for badWord in badWordss {
        if lowercasedText.contains(badWord) {
            print("Found bad word as substring: \(badWord)")
            return true
        }
    }

    return false
}
