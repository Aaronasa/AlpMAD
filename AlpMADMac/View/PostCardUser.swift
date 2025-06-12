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
    @State private var isHovered = false
    @State private var showingPopover = false
    @State private var showingCustomMenu = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with user info, date, and menu
            HStack(alignment: .top) {
                HStack(spacing: 2) {
                    Text("Anonymous (you)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.trailing, 8)
                    Text(formatDate(post.timestamp))
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    showingPopover.toggle()
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                }
                .popover(isPresented: $showingPopover, arrowEdge: .bottom) {
                    VStack(alignment: .leading, spacing: 0) {
                        Button(action: {
                            editedContent = post.content
                            showingEditSheet = true
                            showingPopover = false
                        }) {
                            HStack {
                                Text("Edit")
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
                    .background(Color(NSColor.controlBackgroundColor))
                }
            }
            
            // Content
            Text(post.content)
                .font(.system(size: 14))
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.black)
            
            // Stats (non-interactive for user's own posts)
            HStack(spacing: 24) {
                HStack(spacing: 6) {
                    Image(systemName: "arrowshape.turn.up.left")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text("\(post.commentCount)")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "heart")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text("\(post.likeCount)")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                
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
                        .foregroundColor(Color.gray),
                    alignment: .bottom
                )
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
            .frame(minWidth: 500, minHeight: 400)
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
