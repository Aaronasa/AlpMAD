//
//  PostCard.swift
//  AlpMAD
//
//  Created by Aaron Asa Soelistiono on 18/05/25.
//

import SwiftUI

struct PostCard: View {
    let post: Post
    @EnvironmentObject var postViewModel: PostViewModel
    @EnvironmentObject var replyViewModel: ReplyViewModel
    
    @State private var isLiked: Bool
    @State private var likeCount: Int
    @State private var showReplySheet = false
    
    init(post: Post) {
        self.post = post
        _isLiked = State(initialValue: post.likedByCurrentUser ?? false)
        _likeCount = State(initialValue: post.likeCount)
    }

    let softBlue = Color(red: 160/255, green: 210/255, blue: 235/255)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Anonymous")
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(formatDate(post.timestamp))
                    .font(.subheadline)
                    .padding(.leading, 8)
                    .foregroundColor(.secondary)
            }

            Text(post.content)
                .font(.footnote)

            HStack(spacing: 20) {
                Button(action: {
                    // reply logic (if needed)
                    showReplySheet = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrowshape.turn.up.left")
                            .foregroundColor(.blue)
                        Text("\(post.commentCount)")
                            .foregroundColor(.secondary)
                    }
                    
                }
                .sheet(isPresented: $showReplySheet) {
                                   ReplyView(viewModel: replyViewModel, postId: post.id)
                               }

                Button(action: {
                    if isLiked {
                        postViewModel.unlikePost(post)
                        likeCount -= 1
                    } else {
                        postViewModel.likePost(post)
                        likeCount += 1
                    }
                    isLiked.toggle()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .red)
                        Text("\(likeCount)")
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(softBlue)
                .offset(y: 0.5),
            alignment: .bottom
        )
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


#Preview {
    PostCard(post: Post(
        id: "1",
        userId: "",
        content: "Example post content",
        timestamp: Date(),
        commentCount: 0, likeCount: 3,
        likedByCurrentUser: false
    ))
    .environmentObject(PostViewModel())
    .environmentObject(ReplyViewModel())
}
