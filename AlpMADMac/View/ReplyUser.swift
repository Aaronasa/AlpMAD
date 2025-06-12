//
//  ReplyUser.swift
//  AlpMADMac
//
//  Created by student on 03/06/25.
//

import SwiftUI

struct ReplyUser: View {
    let primaryBlue = Color(red: 74 / 255, green: 144 / 255, blue: 226 / 255)
    let softBlue = Color(red: 160/255, green: 210/255, blue: 235/255)
    let lightGray = Color(red: 248/255, green: 248/255, blue: 250/255)
    let reply: ReplyModel

    @EnvironmentObject var replyViewModel: ReplyViewModel
    @EnvironmentObject var postViewModel: PostViewModel

    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingPopover = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Original Post Section
            if let post = postViewModel.posts.first(where: { $0.id == reply.postId }) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Anonymous")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        Text(formatDate(post.timestamp))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    
                    Text(post.content)
                        .font(.body)
                        .foregroundColor(.black)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(spacing: 20) {
                        HStack(spacing: 6) {
                            Image(systemName: "arrowshape.turn.up.left")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                            Text("\(post.commentCount)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        HStack(spacing: 6) {
                            Image(systemName: "heart")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                            Text("\(post.likeCount)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                }
                .padding(16)
                .background(lightGray)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            }

            // Reply Section
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Anonymous (you)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        Text(formatDate(reply.timestamp))
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }

                    Text(reply.content)
                        .font(.body)
                        .foregroundColor(.black)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Button(action: {
                    showingPopover.toggle()
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                        .font(.title2)
                }
                .popover(isPresented: $showingPopover, arrowEdge: .bottom) {
                    VStack(alignment: .leading, spacing: 0) {
                        Button(action: {
                            replyViewModel.editedContent = reply.content
                            showingEditSheet = true
                            showingPopover = false
                        }) {
                            HStack {
                                Text("Edit")
                                    .foregroundStyle(.gray)
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                        }
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())
                        
                        Divider()
                        
                        Button(action: {
                            showingDeleteAlert = true
                            showingPopover = false
                        }) {
                            HStack {
                                Text("Delete")
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())
                    }
                    .frame(width: 120)
                    .background(Color.white)
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(primaryBlue, lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .padding(16)
        .background(Color.white)
        .sheet(isPresented: $showingEditSheet) {
            EditReplyView(
                content: $replyViewModel.editedContent,
                onSave: {
                    replyViewModel.saveChanges(replyId: reply.id, postId: reply.postId) {
                        showingEditSheet = false
                    }
                },
                onCancel: {
                    replyViewModel.cancelEdit()
                    showingEditSheet = false
                },
                errorMessage: replyViewModel.errorMessage
            )
            .frame(minWidth: 400, minHeight: 200)

        }
        .alert("Delete Reply",
               isPresented: $showingDeleteAlert,
               actions: {
                   Button("Delete", role: .destructive) {
                       replyViewModel.deleteReply(reply)
                   }
                   Button("Cancel", role: .cancel) { }
               },
               message: {
                   Text("Are you sure you want to delete this reply?")
               }
        )
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
            content: "This is a sample post content that demonstrates how the post looks in the reply view.",
            timestamp: Date(),
            commentCount: 5,
            likeCount: 12
        )
    ]

    return ReplyUser(
        reply: ReplyModel(
            id: "1",
            userId: "1",
            postId: "abc123",
            content: "This is a sample reply content that shows how replies are displayed with the new design.",
            timestamp: Date()
        )
    )
    .environmentObject(replyVM)
    .environmentObject(postVM)
    .frame(minWidth: 600, minHeight: 400)
    .background(Color.white)
}
