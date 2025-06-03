//
//  PostCardUser.swift
//  AlpMAD
//
//  Created by Aaron Asa Soelistiono on 22/05/25.
//

import SwiftUI

struct PostCardUser: View {
    let post: Post
    @EnvironmentObject var postViewModel: PostViewModel
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var editedContent = ""

    let softBlue = Color(red: 160/255, green: 210/255, blue: 235/255)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Anonymous (you)")
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(formatDate(post.timestamp))
                    .font(.subheadline)
                    .padding(.leading, 8)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Menu {
                    Button(action: {
                        editedContent = post.content
                        showingEditSheet = true
                    }) {
                        Label("Edit", systemImage: "")
                    }
                    
                    Button(role: .destructive, action: {
                        showingDeleteAlert = true
                    }) {
                        Label("Delete", systemImage: "")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
            }

            Text(post.content)
                .font(.body)

            HStack(spacing: 20) {
                HStack(spacing: 4) {
                    Image(systemName: "arrowshape.turn.up.left")
                        .foregroundColor(.gray)
                    Text("\(post.commentCount)")
                        .foregroundColor(.secondary)
                        .padding(.trailing)
                    Image(systemName: "heart")
                        .foregroundColor(.gray)
                    Text("\(post.likeCount)")
                        .foregroundColor(.secondary)
                    
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(softBlue)
                .offset(y: 0.5),
            alignment: .bottom
        )
        .sheet(isPresented: $showingEditSheet) {
            EditPostView(
                content: $editedContent,
                onSave: {
                    var updatedPost = post
                    updatedPost.content = editedContent
                    let success = postViewModel.updatePost(updatedPost)
                    if success {
                        showingEditSheet = false
                    }
                },
                onCancel: {
                    showingEditSheet = false
                },
                errorMessage: postViewModel.postError
            )
        }
        .alert("Delete Post", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                postViewModel.deletePost(post)
            }
        } message: {
            Text("Are you sure you want to delete this post? This action cannot be undone.")
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    PostCardUser(post: Post(
        id: "1",
        userId: "",
        content: "Example post content",
        timestamp: Date(),
        commentCount: 0,
        likeCount: 3,
        likedByCurrentUser: false
    ))
    .environmentObject(PostViewModel())
}
