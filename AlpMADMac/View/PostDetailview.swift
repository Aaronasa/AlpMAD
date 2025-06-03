//
//  PostDetailview.swift
//  AlpMAD
//
//  Created by Aaron Asa Soelistiono on 23/05/25.
//

import SwiftUI

struct PostDetailview: View {
    let post: Post
    @EnvironmentObject var postViewModel: PostViewModel
    @EnvironmentObject var replyViewModel: ReplyViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var isLiked: Bool
    @State private var likeCount: Int
    @State private var showReplySheet = false
    
    let softBlue = Color(red: 160/255, green: 210/255, blue: 235/255)
    
    init(post: Post) {
        self.post = post
        _isLiked = State(initialValue: post.likedByCurrentUser ?? false)
        _likeCount = State(initialValue: post.likeCount)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
                
                Text("Post")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Anonymous header
                    Text("Anonymous")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                    
                    // Post content
                    Text(post.content)
                        .font(.body)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 20)
                    
                    Text(formatDetailedDate(post.timestamp))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)
                    
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(softBlue)
                    
                    // Interaction buttons
                    HStack(spacing: 32) {
                        Button(action: {
                            showReplySheet = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrowshape.turn.up.left")
                                    .font(.title3)
                                    .foregroundColor(.blue)
                                Text("\(post.commentCount)")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        }
//                        .sheet(isPresented: $showReplySheet) {
//                            ReplyView(viewModel: replyViewModel, postId: post.id)
//                        }

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
                            HStack(spacing: 8) {
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .font(.title3)
                                    .foregroundColor(isLiked ? .red : .red)
                                Text("\(likeCount)")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .background(Color.white)
    }

    private func formatDetailedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a · MMM d, yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    PostDetailview(post: Post(
        id: "1",
        userId: "",
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi a nibh ipsum. Mauris aliquet nisl sed eleifend euismod.",
        timestamp: Date(),
        commentCount: 2,
        likeCount: 2,
        likedByCurrentUser: false
    ))
    .environmentObject(PostViewModel())
    .environmentObject(ReplyViewModel())
}
