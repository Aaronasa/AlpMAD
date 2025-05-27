//
//  EditReplySheet.swift
//  AlpMAD
//
//  Created by student on 27/05/25.
//

import SwiftUI

struct EditReplySheet: View {
    let reply: ReplyModel
    @ObservedObject var replyViewModel: ReplyViewModel
    @Environment(\.dismiss) var dismiss

    @State private var content: String
    @State private var errorMessage: String?

    init(reply: ReplyModel, replyViewModel: ReplyViewModel) {
        self.reply = reply
        self.replyViewModel = replyViewModel
        _content = State(initialValue: reply.content)
    }

    var body: some View {
        EditReplyView(
            content: $content,
            onSave: saveChanges,
            onCancel: { dismiss() },
            errorMessage: errorMessage
        )
    }

    private func saveChanges() {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "Reply can't be empty."
            return
        }

        if badWord.contains(where: { trimmed.lowercased().contains($0) }) {
            errorMessage = "Reply contains inappropriate word."
            return
        }

        replyViewModel.updateReply(replyId: reply.id, newContent: trimmed, postId: "")
        dismiss()
    }
}
