//
//  ConfesView.swift
//  AlpMAD
//
//  Created by Aaron Asa Soelistiono on 18/05/25.
//
import SwiftUI

struct ConfesView: View {
    @State private var postText: String = ""
    @State private var showProfile = false
    @State private var showErrorAlert = false
    @State private var showChat = false
    
    let maxCharacters = 1000
    
    let softBlue = Color(red: 160/255, green: 210/255, blue: 235/255)
    let primaryBlue = Color(red: 74/255, green: 144/255, blue: 226/255)

    @EnvironmentObject var postViewModel: PostViewModel
    @EnvironmentObject var replyViewModel: ReplyViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack {
                // Header Bar
                HStack {
                    Image("Rectangle 6")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 50)
                        .foregroundColor(.blue)
                        .padding(.trailing, 10)
                    Spacer()
                    Image(systemName: "bubble.right")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                        .padding(.trailing, 10)
                        .onTapGesture {
                            showChat = true
                        }
                    Image(systemName: "person")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                        .padding(.trailing, 16)
                        .onTapGesture {
                            showProfile = true
                        }
                }
                .padding(.top)

                Divider().background(softBlue)
                
                // Post Input Area
                VStack(alignment: .leading) {
                    TextEditor(text: $postText)
                        .padding(.top, 30)
                        .frame(height: 100)
                        .padding(.horizontal, 4)
                        .background(Color.clear)
                        .overlay(
                            Group {
                                if postText.isEmpty {
                                    Text("What's on your mind?")
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 8)
                                        .padding(.top, 35)
                                        .allowsHitTesting(false)
                                }
                            }, alignment: .topLeading
                        )
                        .font(.system(size: 17))
                        .padding(.horizontal)
                    
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("\(postText.count) / \(maxCharacters)")
                                .foregroundColor(.gray)
                            Button(action: {
                                let trimmed = postText.trimmingCharacters(in: .whitespacesAndNewlines)
                                guard !trimmed.isEmpty else { return }
                                
                                let success = postViewModel.addPost(content: trimmed)
                                if success {
                                    postText = ""
                                } else {
                                    showErrorAlert = true
                                }
                            }) {
                                Text("Post")
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                                    .background(primaryBlue)
                                    .cornerRadius(8)
                                    .shadow(radius: 3)
                            }
                            .disabled(postText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || postText.count > maxCharacters)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                
                Divider().background(softBlue)
                
                // Post List
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(postViewModel.posts) { post in
                            PostCard(post: post)
                                .environmentObject(postViewModel)
                        }
                    }
                }

                // Navigation destination
                NavigationLink("", destination: ProfileView().environmentObject(authViewModel), isActive: $showProfile)
                    .hidden()
                
                NavigationLink(
                    destination: ListUserChatView(),
                    isActive: $showChat
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .alert("Gagal Memposting", isPresented: $showErrorAlert) {
                Button("OK") {
                    postViewModel.postError = nil
                }
            } message: {
                Text(postViewModel.postError ?? "Terjadi kesalahan yang tidak diketahui")
            }
            .onChange(of: postViewModel.postError) { error in
                if error != nil {
                    showErrorAlert = true
                }
            }
        }
    }
}

#Preview {
    ConfesView()
        .environmentObject(PostViewModel())
        .environmentObject(ReplyViewModel())
        .environmentObject(AuthViewModel())
}
