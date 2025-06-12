import SwiftUI

struct ListUserChatView: View {
    @StateObject private var viewModel = ListUserChatViewModel()
    
    @State private var selectedChatUserId: String?
    
    init(viewModel: ListUserChatViewModel = ListUserChatViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                List {
                    ForEach(viewModel.userChats) { chat in
                        Button {
                            selectedChatUserId = chat.listUserId
                        } label: {
                            UserChatCardView(chat: chat)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(PlainListStyle())
                .frame(maxWidth: 600) // ✅ Batasi lebar list agar lebih nyaman di layar Mac
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .navigationTitle("Chats")
            .onAppear {
                if !isPreview {
                    viewModel.fetchChats()
                }
            }
            // ✅ Navigation to ChatView
            .navigationDestination(isPresented: Binding(
                get: { selectedChatUserId != nil },
                set: { if !$0 { selectedChatUserId = nil } }
            )) {
                if let receiverId = selectedChatUserId {
                    ChatView(viewModel: ChatViewModel(), receiverId: receiverId)
                        .frame(maxWidth: 800, maxHeight: .infinity)
                        .padding()
                }
            }
        }
        .frame(minWidth: 800, minHeight: 600) // ✅ Minimum window size for macOS
    }
}

#Preview {
    let dummyMessages = (1...5).map { i in
        ListUserChat(
            id: UUID().uuidString,
            listUserId: "user\(i)",
            username: "User \(i)",
            lastMessage: Chat(
                id: UUID().uuidString,
                chatId: "chat_\(i)",
                message: "Hello from User \(i)",
                time: Date().addingTimeInterval(Double(-i * 60)),
                senderId: "user\(i)",
                receiveId: "currentUser"
            )
        )
    }

    let mockViewModel = ListUserChatViewModel()
    mockViewModel.userChats = dummyMessages

    return ListUserChatView(viewModel: mockViewModel)
        .frame(width: 1000, height: 700)
}
