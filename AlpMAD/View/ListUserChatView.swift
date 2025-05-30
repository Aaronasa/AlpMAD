//
//  ListUserChatView.swift
//  AlpMAD
//
//  Created by student on 30/05/25.
//

import SwiftUI

struct ListUserChatView: View {
    @StateObject private var viewModel = ListUserChatViewModel()
    @State private var selectedChatUserId: String?
    
    init(viewModel: ListUserChatViewModel = ListUserChatViewModel()) {
            _viewModel = StateObject(wrappedValue: viewModel)
        }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.userChats) { chat in
                    Button {
                        selectedChatUserId = chat.listUserId
                    } label: {
                        UserChatCardView(chat: chat)
                            .padding(.vertical, 8)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets()) // Optional: remove default insets
                }
            }
            .listStyle(PlainListStyle()) 
            .navigationTitle("Chats")
            .onAppear {
                viewModel.fetchChats()
            }
            .background(
                NavigationLink(
                    destination: Group {
                        if let receiverId = selectedChatUserId {
                            ChatView(viewModel: ChatViewModel(), receiverId: receiverId)
                        } else {
                            EmptyView()
                        }
                    },
                    isActive: Binding(
                        get: { selectedChatUserId != nil },
                        set: { if !$0 { selectedChatUserId = nil } }
                    )
                ) {
                    EmptyView()
                }
                .hidden()
            )
        }
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
}

