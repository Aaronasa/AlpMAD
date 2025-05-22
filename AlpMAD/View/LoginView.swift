
//  LoginView.swift
//  AlpMAD
//
//  Created by Aaron Asa Soelistiono on 18/05/25.
//

import SwiftUI

struct LoginView: View {
//    test
    @Binding var showLogin: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @EnvironmentObject var authVM: AuthViewModel

    let textColor = Color(red: 45/255, green: 55/255, blue: 72/255)
    let primaryBlue = Color(red: 74/255, green: 144/255, blue: 226/255)
    let backgroundColor = Color(red: 244/255, green: 246/255, blue: 249/255)
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("Frame 1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 100)
                .padding(.bottom, 60)
            
            
            VStack(spacing: 16) {
                // Email Field
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(primaryBlue, lineWidth: 1)
                    )
                
                // Password Field
                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                    
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
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
            }
            .padding(.horizontal, 16)
            
            // Login Button
            Button(action: {
                guard !email.isEmpty else {
                    alertMessage = "Email tidak boleh kosong"
                    showAlert = true
                    return
                }
                guard !password.isEmpty else {
                    alertMessage = "Password tidak boleh kosong"
                    showAlert = true
                    return
                }
                
                Task {
                    authVM.myUser.email = email
                    authVM.myUser.password = password
                    await authVM.signIn()
                }
            }) {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(primaryBlue)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Register Link
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(textColor)
                Button(action: {
                    authVM.showLogin = false
                }) {
                    Text("Register")
                        .fontWeight(.semibold)
                        .foregroundColor(primaryBlue)
                }
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .background(backgroundColor)
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login Gagal"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showLogin: .constant(true))
            .environmentObject(AuthViewModel())
    }
}
