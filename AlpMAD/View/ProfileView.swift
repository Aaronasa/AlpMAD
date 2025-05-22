//
//  ProfileView.swift
//  AlpMAD
//
//  Created by Aaron Asa Soelistiono on 20/05/25.
//
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var newAge: String = ""
    @State private var newEmail: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var selectedUpdate: UpdateType = .age
    @State private var showingUpdateAlert = false
    @State private var showingDeleteAlert = false
    @State private var showingUpdateSuccess = false
    @State private var updateMessage: String = ""
    
    enum UpdateType {
        case age, email, password
    }
    
    // Colors
    let textColor = Color(red: 45/255, green: 55/255, blue: 72/255)
    let primaryBlue = Color(red: 74/255, green: 144/255, blue: 226/255)
    let backgroundColor = Color(red: 244/255, green: 246/255, blue: 249/255)
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Profile Header
                    VStack(spacing: 8) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(primaryBlue)
                            .padding(.bottom, 10)
                        
                        Text(authViewModel.myUser.email)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(textColor)
                        
                        Text("Age: \(authViewModel.myUser.age)")
                            .font(.headline)
                            .foregroundColor(textColor.opacity(0.8))
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // Update Profile Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Update Profile")
                            .font(.headline)
                            .foregroundColor(textColor)
                        
                        Picker("Update Type", selection: $selectedUpdate) {
                            Text("Age").tag(UpdateType.age)
                            Text("Email").tag(UpdateType.email)
                            Text("Password").tag(UpdateType.password)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.bottom, 10)
                        
                        if selectedUpdate == .age {
                            HStack {
                                TextField("New Age", text: $newAge)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(primaryBlue.opacity(0.5), lineWidth: 1)
                                    )
                                
                                Button(action: {
                                    selectedUpdate = .age
                                    showingUpdateAlert = true
                                }) {
                                    Text("Update")
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 12)
                                        .background(primaryBlue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                        } else if selectedUpdate == .email {
                            VStack(spacing: 10) {
                                TextField("New Email", text: $newEmail)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(primaryBlue.opacity(0.5), lineWidth: 1)
                                    )
                                
                                Button(action: {
                                    selectedUpdate = .email
                                    showingUpdateAlert = true
                                }) {
                                    Text("Update Email")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(primaryBlue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                        } else {
                            VStack(spacing: 10) {
                                SecureField("New Password", text: $newPassword)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(primaryBlue.opacity(0.5), lineWidth: 1)
                                    )
                                
                                SecureField("Confirm Password", text: $confirmPassword)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(primaryBlue.opacity(0.5), lineWidth: 1)
                                    )
                                
                                Button(action: {
                                    if newPassword == confirmPassword && !newPassword.isEmpty {
                                        selectedUpdate = .password
                                        showingUpdateAlert = true
                                    } else {
                                        updateMessage = "Passwords don't match or are empty"
                                        showingUpdateSuccess = true
                                    }
                                }) {
                                    Text("Update Password")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(primaryBlue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Action Buttons
                    VStack(spacing: 15) {
                        Button(action: {
                            Task {
                                authViewModel.signOut()
                            }
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Sign Out")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(primaryBlue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete Account")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Update Profile", isPresented: $showingUpdateAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Update") {
                    Task {
                        switch selectedUpdate {
                        case .age:
                            if let age = Int(newAge) {
                                await authViewModel.updateUser(age: age)
                                updateMessage = "Your age has been updated successfully!"
                                newAge = ""
                            }
                        case .email:
                            if !newEmail.isEmpty {
                                await authViewModel.updateEmail(email: newEmail)
                                updateMessage = "Your email has been updated successfully!"
                                newEmail = ""
                            }
                        case .password:
                            if !newPassword.isEmpty && newPassword == confirmPassword {
                                await authViewModel.updatePassword(password: newPassword)
                                updateMessage = "Your password has been updated successfully!"
                                newPassword = ""
                                confirmPassword = ""
                            }
                        }
                        showingUpdateSuccess = true
                    }
                }
            } message: {
                switch selectedUpdate {
                case .age:
                    Text("Are you sure you want to update your age to \(newAge)?")
                case .email:
                    Text("Are you sure you want to update your email to \(newEmail)?")
                case .password:
                    Text("Are you sure you want to update your password?")
                }
            }
            .alert("Profile Update", isPresented: $showingUpdateSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(updateMessage)
            }
            .alert("Delete Account", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    Task {
                        await authViewModel.deleteUser()
                    }
                }
            } message: {
                Text("Are you sure you want to delete your account? This action cannot be undone.")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
}
