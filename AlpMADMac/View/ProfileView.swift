//
//  ProfileView.swift
//  AlpMADMac
//
//  Created by student on 03/06/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var postViewModel: PostViewModel
    @EnvironmentObject var replyViewModel: ReplyViewModel
    
    @State private var editableEmail: String = ""
    @State private var editablePassword: String = ""
    @State private var editableAge: String = ""
    @State private var showingDeleteAlert = false
    @State private var showingSaveAlert = false
    @State private var saveMessage: String = ""
    @State private var isPasswordVisible = false
    @State private var selectedTab: UpdateType = .edit

    enum UpdateType: String, CaseIterable, Identifiable {
        case edit, post, reply
        var id: String { rawValue }
        var title: String {
            switch self {
            case .edit: return "Edit Profile"
            case .post: return "Posts"
            case .reply: return "Replies"
            }
        }
    }

    let backgroundColor = Color(NSColor.windowBackgroundColor)
    let primaryBlue = Color(red: 74 / 255, green: 144 / 255, blue: 226 / 255)
    let textColor = Color.primary
    let secondaryTextColor = Color.secondary

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Text("Anonymous")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(textColor)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Picker("Update Type", selection: $selectedTab) {
                        ForEach(UpdateType.allCases) { type in
                            Text(type.title).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom)
                }
                .padding([.top, .horizontal], 20)

                Divider()

                Group {
                    switch selectedTab {
                    case .edit:
                        editProfileView
                    case .post:
                        postListView
                    case .reply:
                        replyListView
                    }
                }
                .padding(20)

                Spacer()

                if selectedTab == .edit {
                    actionButtons
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                }
            }
            .frame(minWidth: 500, minHeight: 600)
            .background(backgroundColor)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveProfile()
                    }
                    .foregroundColor(primaryBlue)
                    .font(.system(size: 16, weight: .medium))
                }
            }
            .alert("Save Changes", isPresented: $showingSaveAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(saveMessage)
            }
            .alert("Delete Account", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    Task {
                        await authViewModel.deleteUser()
                    }
                }
            } message: {
                Text(
                    "Are you sure you want to delete your account? This action cannot be undone."
                )
            }
            .onAppear {
                loadCurrentUserData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    postViewModel.fetchUserPosts()
                    replyViewModel.fetchUserReplies()
                }
            }
        }
    }

    var editProfileView: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Email Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(textColor)
                TextField(authViewModel.myUser.email, text: $editableEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity)
            }

            // Password Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(textColor)
                HStack {
                    if isPasswordVisible {
                        TextField(authViewModel.myUser.password, text: $editablePassword)
                    } else {
                        SecureField("Password", text: $editablePassword)
                    }

                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(primaryBlue)
                    }
                    .buttonStyle(BorderlessButtonStyle()) // Important for macOS buttons inside HStack
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            // Age Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Age")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(textColor)
                TextField("New Age", text: $editableAge)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity)
            }
        }
    }

    var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                Task {
                    authViewModel.signOut()
                }
            } label: {
                Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(primaryBlue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            Button {
                showingDeleteAlert = true
            } label: {
                Label("Delete Account", systemImage: "trash")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
    }

    var postListView: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(postViewModel.userPosts) { post in
                    PostCardUser(post: post)
                        .environmentObject(postViewModel)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    var replyListView: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(replyViewModel.userReplies) { reply in
                    ReplyUser(reply: reply)
                        .environmentObject(replyViewModel)
                        .environmentObject(postViewModel)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private func loadCurrentUserData() {
        editableEmail = authViewModel.myUser.email
        editablePassword = authViewModel.myUser.password
        editableAge = String(authViewModel.myUser.age)
    }

    private func saveProfile() {
        Task {
            var emailToUpdate: String? = nil
            var passwordToUpdate: String? = nil
            var ageToUpdate: Int? = nil
            var messages: [String] = []

            if editableEmail != authViewModel.myUser.email && !editableEmail.isEmpty {
                emailToUpdate = editableEmail
                messages.append("Email updated")
            }

            if editablePassword != authViewModel.myUser.password && !editablePassword.isEmpty {
                passwordToUpdate = editablePassword
                messages.append("Password updated")
            }

            if let newAge = Int(editableAge), newAge != authViewModel.myUser.age {
                ageToUpdate = newAge
                messages.append("Age updated")
            }

            if emailToUpdate != nil || passwordToUpdate != nil || ageToUpdate != nil {
                await authViewModel.updateUser(
                    email: emailToUpdate,
                    password: passwordToUpdate,
                    age: ageToUpdate
                )

                await MainActor.run {
                    saveMessage = messages.joined(separator: ", ") + " successfully!"
                    showingSaveAlert = true
                }
            } else {
                await MainActor.run {
                    saveMessage = "No changes detected."
                    showingSaveAlert = true
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
            .environmentObject(PostViewModel())
            .environmentObject(ReplyViewModel())
            .frame(width: 600, height: 700)
    }
}
