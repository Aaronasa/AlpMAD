//
//  ProfileView.swift
//  AlpMAD
//
//  Created by Aaron Asa Soelistiono on 20/05/25.
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
    @Environment(\.presentationMode) var presentationMode

    enum UpdateType {
        case edit, post, reply
    }

    let backgroundColor = Color(UIColor.systemBackground)
    let primaryBlue = Color(red: 74 / 255, green: 144 / 255, blue: 226 / 255)
    let textColor = Color.primary
    let secondaryTextColor = Color.secondary

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        Text("Anonymous")
                            .padding(.leading, -180)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(textColor)

                        Picker("Update Type", selection: $selectedTab) {
                            Text("Edit Profile").tag(UpdateType.edit)
                            Text("Posts").tag(UpdateType.post)
                            Text("Replies").tag(UpdateType.reply)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                    }
                    .padding(.top, 20)
                    if selectedTab == .edit {
                        // Form Section
                        VStack(alignment: .leading, spacing: 24) {
                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(textColor)
                                TextField(
                                    authViewModel.myUser.email,
                                    text: $editableEmail
                                )
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(
                                            primaryBlue.opacity(0.5),
                                            lineWidth: 1
                                        )
                                )
                            }

                            // Password Field
                            Text("Password")
                                .padding(.bottom, -15)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(textColor)
                            HStack {
                                if isPasswordVisible {
                                    TextField(
                                        authViewModel.myUser.password,
                                        text: $editablePassword
                                    )
                                } else {
                                    SecureField(
                                        "Password",
                                        text: $editablePassword
                                    )
                                }

                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(
                                        systemName: isPasswordVisible
                                            ? "eye.slash.fill" : "eye.fill"
                                    )
                                    .foregroundColor(primaryBlue)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(primaryBlue, lineWidth: 1)
                            )

                            Text("Age")
                                .padding(.bottom, -15)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(textColor)
                            TextField("New Age", text: $editableAge)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(
                                            primaryBlue.opacity(0.5),
                                            lineWidth: 1
                                        )
                                )

                        }
                        .padding(.horizontal, 20)

                        Spacer()

                        // Action Buttons
                        VStack(spacing: 12) {
                            // Sign Out Button
                            Button(action: {
                                Task {
                                    authViewModel.signOut()
                                }
                            }) {
                                HStack {
                                    Image(
                                        systemName:
                                            "rectangle.portrait.and.arrow.right"
                                    )
                                    .font(.system(size: 16, weight: .medium))
                                    Text("Sign Out")
                                        .font(
                                            .system(size: 16, weight: .semibold)
                                        )
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(primaryBlue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }

                            // Delete Account Button
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(
                                            .system(size: 16, weight: .medium)
                                        )
                                    Text("Delete Account")
                                        .font(
                                            .system(size: 16, weight: .semibold)
                                        )
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)

                    } else if selectedTab == .post {
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(postViewModel.userPosts) { post in
                                    PostCardUser(post: post)
                                        .environmentObject(postViewModel)
                                }
                            }
                        }
                    } else if selectedTab == .reply {
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(replyViewModel.userReplies) { reply in
                                    ReplyUser(reply: reply)
                                        .environmentObject(replyViewModel)
                                        .environmentObject(postViewModel)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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

            if editableEmail != authViewModel.myUser.email
                && !editableEmail.isEmpty
            {
                emailToUpdate = editableEmail
                messages.append("Email updated")
            }

            if editablePassword != authViewModel.myUser.password
                && !editablePassword.isEmpty
            {
                passwordToUpdate = editablePassword
                messages.append("Password updated")
            }

            if let newAge = Int(editableAge), newAge != authViewModel.myUser.age
            {
                ageToUpdate = newAge
                messages.append("Age updated")
            }

            if emailToUpdate != nil || passwordToUpdate != nil
                || ageToUpdate != nil
            {
                await authViewModel.updateUser(
                    email: emailToUpdate,
                    password: passwordToUpdate,
                    age: ageToUpdate
                )

                await MainActor.run {
                    saveMessage =
                        messages.joined(separator: ", ") + " successfully!"
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
    }
}
