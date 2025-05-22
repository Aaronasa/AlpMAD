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
    let maxCharacters = 1000

    let softBlue = Color(red: 160/255, green: 210/255, blue: 235/255)
    let primaryBlue = Color(red: 74/255, green: 144/255, blue: 226/255)

    @EnvironmentObject var postViewModel: PostViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
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
                    NavigationLink(destination: ProfileView().environmentObject(authViewModel), isActive: $showProfile) {
                        Image(systemName: "person")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                            .padding(.trailing, 16)
                            .onTapGesture {
                                showProfile = true
                            }
                    }
                }
                .padding(.top)

                Divider().background(softBlue)

                VStack(alignment: .leading) {
                    TextEditor(text: $postText)
                        .padding(.top, 30)
                        .frame(height: 100)
                        .padding(.horizontal, 4)
                        .background(Color.clear)
                        .overlay(
                            Group {
                                if postText.isEmpty {
                                    Text("What’s on your mind?")
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
                                postViewModel.addPost(content: trimmed)
                                postText = ""
                            }) {
                                Text("Post")
                                    .foregroundColor(.black)
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

                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(postViewModel.posts) { post in
                            PostCard(post: post)
                                .environmentObject(postViewModel)
                        }
                    }
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    ConfesView()
        .environmentObject(PostViewModel())
        .environmentObject(AuthViewModel())
}
