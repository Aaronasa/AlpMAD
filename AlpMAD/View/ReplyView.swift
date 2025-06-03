import SwiftUI

struct ReplyView: View {
    @ObservedObject var viewModel: ReplyViewModel
    let postId: String

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 3.5)
                .frame(width: 75, height: 7)
                .foregroundColor(Color(red: 74/255, green: 144/255, blue: 226/255))
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
                            .padding(.top, 14)
                            .padding(.leading, 20)
                    }

                    TextField(
                        "Add a reply",
                        text: Binding(
                            get: { viewModel.newReplyText },
                            set: { newValue in
                                if newValue.count <= 500 {
                                    viewModel.newReplyText = newValue
                                }
                            }
                        )
                    )
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8).stroke(
                            Color.gray.opacity(0)
                        )
                    )
                    .padding(.horizontal)
                }

                HStack {
                    Spacer()
                    Text("\(viewModel.newReplyText.count) / 500")
                        .font(.caption)
                        .foregroundColor(
                            viewModel.newReplyText.count == 500 ? .red : .gray
                        )

                    Button("Post") {
                        viewModel.postReply(to: postId)
                    }
                    .disabled(
                        viewModel.newReplyText.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty
                    )
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(
                        Color(red: 74 / 255, green: 144 / 255, blue: 226 / 255)
                    )
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
    }
}

#Preview {
    let vm = ReplyViewModel()
    vm.replies = [
        Reply(postId: "1", content: "Test reply", timestamp: Date())
    ]
    return ReplyView(viewModel: vm, postId: "sample")
}
