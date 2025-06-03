//
//  PostCard.swift
//  AlpMAD
//
//  Created by Aaron Asa Soelistiono on 18/05/25.
//

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
    @State private var showDetailView = false
    @State private var isHovered = false
    
    init(post: Post) {
        self.post = post
        _isLiked = State(initialValue: post.likedByCurrentUser ?? false)
        _likeCount = State(initialValue: post.likeCount)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with user info and date
            HStack(alignment: .top) {
                Text("Anonymous")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.black)
                    .padding(.trailing, 8)
                
                Text(formatDate(post.timestamp))
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            // Content area - tappable
            Button(action: {
                showDetailView = true
            }) {
                HStack {
                    Text(post.content)
                        .font(.system(size: 14))
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.black)
                    
                    Spacer()
                }
            }
            .buttonStyle(PlainButtonStyle())
            .contentShape(Rectangle())
            
            // Action buttons
            HStack(spacing: 24) {
                // Reply button
                Button(action: {
                    showReplySheet = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrowshape.turn.up.left")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                        Text("\(post.commentCount)")
                            .font(.system(size: 13))
                            .foregroundColor(Color.gray)
                    }
                }
                .buttonStyle(PlainButtonStyle())
//                .sheet(isPresented: $showReplySheet) {
//                    ReplyView(viewModel: replyViewModel, postId: post.id)
//                        .frame(minWidth: 500, minHeight: 400)
//                }
                
                // Like button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if isLiked {
                            postViewModel.unlikePost(post)
                            likeCount -= 1
                        } else {
                            postViewModel.likePost(post)
                            likeCount += 1
                        }
                        isLiked.toggle()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 14))
                            .foregroundColor(isLiked ? .red : .red)
                        Text("\(likeCount)")
                            .font(.system(size: 13))
                            .foregroundColor(Color.gray)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(isLiked ? 1.1 : 1.0)
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            Rectangle()
                .fill(Color.white)
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(Color(NSColor.separatorColor)),
                    alignment: .bottom
                )
        )
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .background(
            Rectangle()
                .fill(isHovered ? Color(NSColor.controlAccentColor).opacity(0.05) : Color.clear)
        )
        .sheet(isPresented: $showDetailView) {
            PostDetailview(post: post)
                .environmentObject(postViewModel)
                .environmentObject(replyViewModel)
                .frame(minWidth: 600, minHeight: 500)
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    VStack(spacing: 0) {
        PostCard(post: Post(
            id: "1",
            userId: "",
            content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi a nibh ipsum. Mauris aliquet nisl sed eleifend euismod.",
            timestamp: Date(),
            commentCount: 2,
            likeCount: 2,
            likedByCurrentUser: false
        ))
    }
    .environmentObject(PostViewModel())
    .environmentObject(ReplyViewModel())
    .frame(width: 600)
}
