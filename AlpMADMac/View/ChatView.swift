import SwiftUI
import FirebaseAuth

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    var receiverId: String

    @State private var messageText: String = ""
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.messages.indices, id: \.self) { index in
                            let message = viewModel.messages[index]
                            let showDate: Bool = {
                                if index == 0 { return true }
                                let prevMessage = viewModel.messages[index - 1]
                                return !Calendar.current.isDate(prevMessage.time, inSameDayAs: message.time)
                            }()

                            Group {
                                if showDate {
                                    dateCardView(date: message.time)
                                }

                                if viewModel.isCurrentUser(message) {
                                    chatCardUser1View(message: message)
                                } else {
                                    chatCardUser2View(message: message)
                                }
                            }
                            .id(index)
                        }
                    }
                    .padding(.top)
                }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation {
                        scrollViewProxy.scrollTo(viewModel.messages.count - 1, anchor: .bottom)
                    }
                }
            }

            Divider()

            HStack {
                TextField("Type your message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isTextFieldFocused)
                    .onTapGesture {
                        isTextFieldFocused = true
                    }

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
                .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .frame(maxWidth: 700) // ✅ batas maksimal lebar konten
        .padding(.horizontal, 20) // ✅ padding kiri-kanan biar tidak mepet
        .padding(.vertical, 10)
        .onAppear {
            if !isPreview {
                let currentUserId = Auth.auth().currentUser?.uid ?? ""
                viewModel.observeMessages(from: currentUserId, to: receiverId)
            }
        }
        .alert(item: $viewModel.chatError) { error in
            Alert(title: Text("Peringatan"),
                  message: Text(error.value),
                  dismissButton: .default(Text("OK")) {
                      viewModel.chatError = nil
                  })
        }
    }

    private var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

    private func sendMessage() {
        let trimmedText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }

        viewModel.sendMessage(to: receiverId, messageText: trimmedText)
        if viewModel.chatError == nil {
            messageText = ""
            isTextFieldFocused = false
        }
    }
}

struct IdentifiableString: Identifiable {
    let id = UUID()
    let value: String
}

#Preview {
    let currentUserId = "1"
    let otherUserId = "2"

    let messages = [
        Chat(
            id: UUID().uuidString,
            chatId: "1_2",
            message: "Hello from logged-in user!",
            time: Calendar.current.date(byAdding: .minute, value: -10, to: Date())!,
            senderId: currentUserId,
            receiveId: otherUserId
        ),
        Chat(
            id: UUID().uuidString,
            chatId: "1_2",
            message: "Hi! I'm the other user.",
            time: Date(),
            senderId: otherUserId,
            receiveId: currentUserId
        )
    ]

    let mockViewModel = ChatViewModel(overrideUserId: currentUserId)
    mockViewModel.messages = messages

    return ChatView(viewModel: mockViewModel, receiverId: otherUserId)
        .frame(width: 1000, height: 700) // ✅ Ukuran preview di macOS
}