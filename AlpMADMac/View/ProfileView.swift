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
        var icon: String {
            switch self {
            case .edit: return "person.crop.circle"
            case .post: return "doc.text"
            case .reply: return "bubble.left.and.bubble.right"
            }
        }
    }

    // Enhanced Color Scheme
    let backgroundColor = Color(red: 0.98, green: 0.98, blue: 1.0) // Light blue-tinted background
    let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.9) // Vibrant blue
    let accentBlue = Color(red: 0.1, green: 0.3, blue: 0.8) // Darker blue for highlights
    let cardBackground = Color.white
    let textColor = Color(red: 0.1, green: 0.1, blue: 0.1) // Rich dark gray
    let secondaryTextColor = Color(red: 0.4, green: 0.4, blue: 0.4)
    let borderColor = Color(red: 0.9, green: 0.9, blue: 0.9)

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Enhanced Header with Profile Info
                profileHeader
                
                // Beautiful Tab Bar
                customTabBar
                
                Divider()
                    .background(borderColor)

                // Content Area with Card Design
                ZStack {
                    backgroundColor
                    
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
                    .padding(.top, 20)
                }

                Spacer()

                if selectedTab == .edit {
                    actionButtons
                        .padding(.horizontal, 24)
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
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(primaryBlue.opacity(0.1))
                    .cornerRadius(8)
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
                Text("Are you sure you want to delete your account? This action cannot be undone.")
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
    
    var profileHeader: some View {
        VStack(spacing: 16) {
            // Profile Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [primaryBlue, accentBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(.white)
            }
            
            // User Info
            VStack(spacing: 4) {
                Text(authViewModel.myUser.email)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(textColor)
                
                Text("Age: \(authViewModel.myUser.age)")
                    .font(.subheadline)
                    .foregroundColor(secondaryTextColor)
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 24)
        .background(cardBackground)
    }
    
    var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(UpdateType.allCases) { type in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = type
                    }
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: type.icon)
                            .font(.system(size: 18, weight: .medium))
                        
                        Text(type.title)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(selectedTab == type ? primaryBlue : secondaryTextColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedTab == type ? primaryBlue.opacity(0.1) : Color.clear)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(selectedTab == type ? primaryBlue.opacity(0.3) : Color.clear, lineWidth: 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(cardBackground)
    }

    var editProfileView: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Form Card
                VStack(alignment: .leading, spacing: 24) {
                    // Email Field
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Email Address", systemImage: "envelope")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(textColor)
                        
                        TextField(authViewModel.myUser.email, text: $editableEmail)
                            .textFieldStyle(CustomTextFieldStyle())
                            .foregroundColor(textColor)
                    }

                    // Password Field
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Password", systemImage: "lock")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(textColor)
                        
                        HStack {
                            Group {
                                if isPasswordVisible {
                                    TextField("Enter new password", text: $editablePassword)
                                } else {
                                    SecureField("Enter new password", text: $editablePassword)
                                }
                            }
                            .foregroundColor(textColor)

                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    isPasswordVisible.toggle()
                                }
                            } label: {
                                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(primaryBlue)
                                    .font(.system(size: 16))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .textFieldStyle(CustomTextFieldStyle())
                    }

                    // Age Field
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Age", systemImage: "calendar")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(textColor)
                        
                        TextField("Enter your age", text: $editableAge)
                            .textFieldStyle(CustomTextFieldStyle())
                            .foregroundColor(textColor)
                    }
                }
                .padding(24)
                .background(cardBackground)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
            }
            .padding(.horizontal, 24)
        }
    }

    var actionButtons: some View {
        VStack(spacing: 16) {
            Button {
                Task {
                    authViewModel.signOut()
                }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 16, weight: .medium))
                    Text("Sign Out")
                        .font(.system(size: 16, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [primaryBlue, accentBlue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: primaryBlue.opacity(0.3), radius: 6, x: 0, y: 3)
            }
            .buttonStyle(PlainButtonStyle())

            Button {
                showingDeleteAlert = true
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                    Text("Delete Account")
                        .font(.system(size: 16, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [Color.red, Color.red.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: Color.red.opacity(0.3), radius: 6, x: 0, y: 3)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    var postListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(postViewModel.userPosts) { post in
                    PostCardUser(post: post)
                        .environmentObject(postViewModel)
                        .background(cardBackground)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                }
            }
            .padding(.horizontal, 24)
        }
    }

    var replyListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(replyViewModel.userReplies) { reply in
                    ReplyUser(reply: reply)
                        .environmentObject(replyViewModel)
                        .environmentObject(postViewModel)
                        .background(cardBackground)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                }
            }
            .padding(.horizontal, 24)
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

// Custom Text Field Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 0.9, green: 0.9, blue: 0.9), lineWidth: 1)
            )
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
            .environmentObject(PostViewModel())
            .environmentObject(ReplyViewModel())
    }
}
