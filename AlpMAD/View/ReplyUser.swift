//
//  ReplyUser.swift
//  AlpMAD
//
//  Created by student on 27/05/25.
//

import SwiftUI

struct ReplyUser: View {
    let primaryBlue = Color(red: 74 / 255, green: 144 / 255, blue: 226 / 255)
    let softBlue = Color(red: 160/255, green: 210/255, blue: 235/255)
    let reply: ReplyModel
    @EnvironmentObject var replyViewModel: ReplyViewModel
    @EnvironmentObject var postViewModel: PostViewModel

    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - Original Post
            if let post = postViewModel.posts.first(where: {
                $0.id == reply.postId
            }) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Anonymous")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(formatDate(post.timestamp))
                            .font(.subheadline)
                            .padding(.leading, 8)
                            .foregroundColor(.secondary)
                        Spacer()
                        
                    }
                    .padding(.vertical, 5)
                    
                    Text(post.content)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding(.vertical, 5)
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

                .background(Color(.systemBackground))

                }

            
              
            

            // MARK: - User Reply
            HStack(alignment: .top, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack{
                        Text("Anonymous (you)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(formatDate(reply.timestamp))
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    Text(reply.content)
                        .font(.body)
                        .foregroundColor(.primary)
                }

                Spacer()

                Menu {
                    Button("Edit") {
                        showingEditSheet = true
                    }
                    Button("Delete", role: .destructive) {
                        showingDeleteAlert = true
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
            }
            .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(primaryBlue, lineWidth: 2)
                )

                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(softBlue)
                        .offset(y: 0.5),
                    alignment: .bottom
                )        }
        .padding()
        .sheet(isPresented: $showingEditSheet) {
            EditReplySheet(reply: reply, replyViewModel: replyViewModel)
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete Reply"),
                message: Text("Are you sure you want to delete this reply?"),
                primaryButton: .destructive(Text("Delete")) {
                    replyViewModel.deleteReply(reply)
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    let replyVM = ReplyViewModel()
    let postVM = PostViewModel()
    postVM.posts = [
        Post(
            id: "abc123",
            userId: "123",
            content: "This is a post.",
            timestamp: Date(),
            commentCount: 2,
            likeCount: 2
        )
    ]

    return ReplyUser(
        reply: ReplyModel(
            id: "1",
            userId: "1",
            postId: "abc123",
            content: "This is a reply.",
            timestamp: Date()
        )
    )
    .environmentObject(replyVM)
    .environmentObject(postVM)
}
