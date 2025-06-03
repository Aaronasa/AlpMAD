//
//  LoadToken.swift
//  AlpMAD
//
//  Created by Aaron Asa Soelistiono on 24/05/25.
//

import Foundation

class Tokenizer {
    private var wordIndex: [String: Int] = [:]

    init?(filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let index = json["word_index"] as? [String: Int] else {
            return nil
        }
        self.wordIndex = index
    }

    func encode(_ text: String, maxLength: Int) -> [Int] {
        let tokens = text.lowercased().split(separator: " ").map { String($0) }
        var result = [Int](repeating: 0, count: maxLength)
        for i in 0..<min(tokens.count, maxLength) {
            result[i] = wordIndex[tokens[i]] ?? 0
        }
        return result
    }
}
