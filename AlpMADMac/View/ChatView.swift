//
//  ChatView.swift
//  AlpMAD
//
//  Created by student on 30/05/25.
//

import SwiftUI
import FirebaseAuth

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    var receiverId: String

    @State private var messageText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var showAlert = false
    @State private var alertMessage = ""

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
                .background(Color.white) // White background for ScrollView
                .onChange(of: viewModel.messages.count) { _ in
                    // Auto-scroll to bottom on new message
                    withAnimation {
                        scrollViewProxy.scrollTo(viewModel.messages.count - 1, anchor: .bottom)
                    }
                }
            }

            Divider()

            HStack {
                TextField("Type your message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.black) // Text color when typing
                    .accentColor(.black) // Cursor color
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
            .background(Color.white) // White background for input area
        }
        .background(Color.white) // White background for entire VStack
        .onAppear {
            if !isPreview {
                let currentUserId = Auth.auth().currentUser?.uid ?? ""
                viewModel.observeMessages(from: currentUserId, to: receiverId)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Peringatan"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onReceive(viewModel.$chatError) { error in
            if let error = error {
                alertMessage = error
                showAlert = true
                viewModel.chatError = nil // Reset error after showing
            }
        }
    }

    private var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

    private func sendMessage() {
        let trimmedText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }

        let success = viewModel.sendMessage(to: receiverId, messageText: trimmedText)
        
        if success {
            messageText = ""
            isTextFieldFocused = false // Dismiss keyboard after sending
        } else {
            // Error handling sudah dilakukan di onReceive viewModel.$chatError
            // Jadi tidak perlu action tambahan di sini
        }
    }
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
}
