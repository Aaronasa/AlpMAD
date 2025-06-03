//
//  ReplyView.swift
//  AlpMAD
//
//  Created by student on 03/06/25.
//

import SwiftUI

struct ReplyView: View {
    @ObservedObject var viewModel: ReplyViewModel
    let postId: String

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(width: 75, height: 7)
                .foregroundColor(Color(red: 74/255, green: 144/255, blue: 226/255))
                .cornerRadius(3.5)
                .padding(.top, 10)

            Text("Replies")
                .font(.headline)
                .padding(10)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.replies(for: postId)) { reply in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Anonymous")
                                    .font(.subheadline)
                                    .bold()
                                Text(reply.timestamp.timeAgoDisplay())
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Text(reply.content)
                                .font(.body)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                if let error = viewModel.replyError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }

                ZStack(alignment: .topLeading) {
                    if viewModel.newReplyText.isEmpty {
                        Text("Add a reply")
                            .foregroundColor(Color.gray.opacity(0.6))
                            .padding(.top, 12)
                            .padding(.leading, 6)
                    }

                    TextEditor(text: Binding(
                        get: { viewModel.newReplyText },
                        set: { newValue in
                            if newValue.count <= 500 {
                                viewModel.newReplyText = newValue
                            }
                        }
                    ))
                    .frame(minHeight: 80)
                    .padding(6)
                    .background(Color(NSColor.textBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3))
                    )
                    .cornerRadius(8)
                    .padding(.horizontal)
                }

                HStack {
                    Spacer()
                    Text("\(viewModel.newReplyText.count) / 500")
                        .font(.caption)
                        .foregroundColor(viewModel.newReplyText.count == 500 ? .red : .gray)

                    Button("Post") {
                        viewModel.postReply(to: postId)
                    }
                    .disabled(viewModel.newReplyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(red: 74/255, green: 144/255, blue: 226/255))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                }
                .padding(.horizontal)
                .padding(.bottom, 15)
            }
        }
        .onAppear {
            viewModel.fetchReplies(for: postId)
        }
        .frame(minWidth: 400, minHeight: 500)
    }
}

#Preview {
    let vm = ReplyViewModel()
    vm.replies = [
        ReplyModel(userId: "", postId: "1", content: "Test reply", timestamp: Date())
    ]
    return ReplyView(viewModel: vm, postId: "sample")
}
