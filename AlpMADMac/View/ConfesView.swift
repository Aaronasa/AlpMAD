//
//  ConfesView.swift
//  AlpMAD
//
//  Created by Aaron Asa Soelistiono on 03/06/25.
//

import SwiftUI

struct ConfesView: View {
    @State private var postText: String = ""
    @State private var showProfile = false
    @State private var showErrorAlert = false
    @FocusState private var isTextFieldFocused: Bool
    let maxCharacters = 1000
    
    let softBlue = Color(red: 160/255, green: 210/255, blue: 235/255)
    let primaryBlue = Color(red: 74/255, green: 144/255, blue: 226/255)

    @EnvironmentObject var postViewModel: PostViewModel
    @EnvironmentObject var replyViewModel: ReplyViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                Image("Rectangle 8")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 50)
                    .foregroundColor(.blue)
                    .padding(.trailing, 10)

                Spacer()

                HStack(spacing: 16) {
                    Button(action: {
                        // Chat/Messages action
                    }) {
                        Image(systemName: "bubble.right")
                            .font(.system(size: 18))
                            .foregroundColor(primaryBlue)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        showProfile = true
                    }) {
                        Image(systemName: "person")
                            .font(.system(size: 18))
                            .foregroundColor(primaryBlue)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(Color.white)
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color.blue),
                alignment: .bottom
            )

            // Post Composition Area
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        ZStack(alignment: .topLeading) {
                            if postText.isEmpty {
                                Text("What's on your mind?")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16))
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                            }

                            TextEditor(text: $postText)
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .frame(minHeight: 80)
                                .focused($isTextFieldFocused)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)


                        // Bottom row with character count and post button
                        HStack {
                            Spacer()

                            Text("\(postText.count) / \(maxCharacters)")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)

                            Button(action: {
                                let trimmed = postText.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                )
                                guard !trimmed.isEmpty else { return }

                                let success = postViewModel.addPost(
                                    content: trimmed
                                )
                                if success {
                                    postText = ""
                                    isTextFieldFocused = false
                                } else {
                                    showErrorAlert = true
                                }
                            }) {
                                Text("Post")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(postButtonColor)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(
                                postText.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                ).isEmpty || postText.count > maxCharacters
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                }

                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(primaryBlue)
            }
            .background(Color.white)

            // Post List
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(postViewModel.posts) { post in
                        PostCard(post: post)
                            .environmentObject(postViewModel)
                            .environmentObject(replyViewModel)
                    }
                }
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
        //        .sheet(isPresented: $showProfile) {
        //            ProfileView()
        //                .environmentObject(authViewModel)
        //                .frame(minWidth: 500, minHeight: 400)
        //        }
        .alert("Gagal Memposting", isPresented: $showErrorAlert) {
            Button("OK") {
                postViewModel.postError = nil
            }
        } message: {
            Text(
                postViewModel.postError
                    ?? "Terjadi kesalahan yang tidak diketahui"
            )
        }
        .onChange(of: postViewModel.postError) { error in
            if error != nil {
                showErrorAlert = true
            }
        }
        .onTapGesture {
            // Dismiss focus when tapping outside
            isTextFieldFocused = false
        }
    }

    private var postButtonColor: Color {
        let isEmpty = postText.trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
        let tooLong = postText.count > maxCharacters

        if isEmpty || tooLong {
            return Color.blue.opacity(0.4)
        } else {
            return Color.blue
        }
    }
}

#Preview {
    ConfesView()
        .environmentObject(PostViewModel())
        .environmentObject(ReplyViewModel())
        .environmentObject(AuthViewModel())
        .frame(width: 800, height: 600)
}
